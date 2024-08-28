#!/usr/bin/env groovy

/* IMPORTANT:
 *
 * In order to make this pipeline work, the following configuration on Jenkins is required:
 * - slave with a specific label (see pipeline.agent.label below)
 * - credentials plugin should be installed and have the secrets with the following names:
 *   + lciadm100credentials (token to access Artifactory)
 */

def defaultBobImage = 'armdocker.rnd.ericsson.se/sandbox/adp-staging/adp-cicd/bob.2.0:1.7.0-101'
def bob = new BobCommand()
        .bobImage(defaultBobImage)
        .needDockerSocket(true)
        .toString()
def failedStage = ''
pipeline {
    agent {
        label 'Cloud-Native'
    }
    stages {
        stage('Clean') {
            steps {
                sh("${bob} clean")
            }
        }
        stage('Set working directory/prepare paths') {
            steps {
                script {
                    sh "${bob} set-working-directory"
                    sh "${bob} prepare-cniv-dockerfile-paths"
                }
            }
        }
        stage('Inject Credential Files') {
            steps {
                withCredentials([file(credentialsId: 'lciadm100-docker-auth', variable: 'dockerConfig')]) {
                    sh "install -m 600 ${dockerConfig} ${HOME}/.docker/config.json"
                }
            }
        }
        stage('Checkout Base Image Git Repository') {
            steps {
                git branch: 'master',
                     credentialsId: 'enmadm100_private_key',
                     url: '${GERRIT_MIRROR}/OSS/ENM-Parent/SQ-Gate/com.ericsson.oss.containerisation/eric-enm-cniv-dps-benchmark'
                sh '''
                    git remote set-url origin --push ${GERRIT_CENTRAL}/OSS/ENM-Parent/SQ-Gate/com.ericsson.oss.containerisation/eric-enm-cniv-dps-benchmark
                '''
            }
        }
        stage('Prepare Release Build') {
            steps {
                sh "${bob} prepare-release-build"
            }
            post {
                failure {
                    script {
                        failedStage = env.STAGE_NAME
                    }
                }
            }
        }
        stage('Helm Dep Up') {
            steps {
                sh "${bob} helm-dep-up"
            }
            post {
                failure {
                    script {
                        failedStage = env.STAGE_NAME
                    }
                }
            }
        }

        stage('Get CBOS newest version') {
            steps {
                script {
                    sh "chmod +x getReleaseVersion.sh"
                    sh "./getReleaseVersion.sh"
                }
            }
        }

        stage('Prepare Paths and Build/Push Base Image') {
            steps {
                sh "${bob} prepare-docker-image-paths"
                sh "${bob} build-and-push-base-image"
            }
            post {
                failure {
                    script {
                        failedStage = env.STAGE_NAME
                    }
                }
            }
        }
        stage ('Build/Push Docker Images') {
            steps {
                parallel(
                        "build-and-push-neo4j": {
                            sh "${bob} build-and-push-images:build-and-push-neo4j"
                        },
                        "build-and-push-neo4j-populator": {
                            sh "${bob} build-and-push-images:build-and-push-neo4j-populator"
                        },
                        "build-and-push-neo4j-load-profiles": {
                            sh "${bob} build-and-push-images:build-and-push-neo4j-load-profiles"
                        },
                        "build-and-push-metric-load-generator": {
                            sh "${bob} build-and-push-images:build-and-push-metric-load-generator"
                        },
                        "build-and-push-load-control-client": {
                            sh "${bob} build-and-push-images:build-and-push-load-control-client"
                        },
                        "build-and-push-load-control-service": {
                            sh "${bob} build-and-push-images:build-and-push-load-control-service"
                        }
                )
            }
            post {
                failure {
                    script {
                        failedStage = env.STAGE_NAME
                    }
                }
            }
        }

        stage('Docker Image Design Rule Checks') {
            steps {
                parallel(
                        "check-base": {
                            sh "${bob} image-design-rule-checks-release:check-base"
                        },
                        "check-neo4j": {
                            sh "${bob} image-design-rule-checks-release:check-neo4j"
                        },
                        "check-neo4j-populator": {
                            sh "${bob} image-design-rule-checks-release:check-neo4j-populator"
                        },
                        "check-neo4j-load-profiles": {
                            sh "${bob} image-design-rule-checks-release:check-neo4j-load-profiles"
                        },
                        "check-metric-load-generator": {
                            sh "${bob} image-design-rule-checks-release:check-metric-load-generator"
                        },
                        "check-load-control-client": {
                            sh "${bob} image-design-rule-checks-release:check-load-control-client"
                        },
                        "check-load-control-service": {
                            sh "${bob} image-design-rule-checks-release:check-load-control-service"
                        }
                )
            }
            post {
                failure {
                    script {
                        failedStage = env.STAGE_NAME
                    }
                }
            }
        }
        stage('Build & Push Helm Chart') {
            steps {
                sh "${bob} build-helm"
                sh "${bob} push-helm"
            }
            post {
                failure {
                    script {
                        failedStage = env.STAGE_NAME
                    }
                }
            }
        }
        stage('Create Trivy Directory') {
            steps {
                sh "${bob} trivy-inline-scan:create-dir"
            }
        }
        stage ('Trivy Scan') {
            steps {
                parallel(
                        "scan-base": {
                            sh "${bob} trivy-inline-scan:scan-base"
                        },
                        "scan-neo4j": {
                            sh "${bob} trivy-inline-scan:scan-neo4j"
                        },
                        "scan-neo4j-populator": {
                            sh "${bob} trivy-inline-scan:scan-neo4j-populator"
                        },
                        "scan-neo4j-load-profiles": {
                            sh "${bob} trivy-inline-scan:scan-neo4j-load-profiles"
                        },
                        "scan-metric-load-generator": {
                            sh "${bob} trivy-inline-scan:scan-metric-load-generator"
                        },
                        "scan-load-control-client": {
                            sh "${bob} trivy-inline-scan:scan-load-control-client"
                        },
                        "scan-load-control-service": {
                            sh "${bob} trivy-inline-scan:scan-load-control-service"
                        }
                )
            }
        }
        stage('Anchore/Grype Scan') {
            steps {
                parallel(
                        "grype-scan-base": {
                            sh "${bob} grype-scan:grype-scan-base"
                        },
                        "grype-scan-neo4j": {
                            sh "${bob} grype-scan:grype-scan-neo4j"
                        },
                        "grype-scan-neo4j-populator": {
                            sh "${bob} grype-scan:grype-scan-neo4j-populator"
                        },
                        "grype-scan-neo4j-load-profiles": {
                            sh "${bob} grype-scan:grype-scan-neo4j-load-profiles"
                        },
                        "grype-scan-metric-load-generator": {
                            sh "${bob} grype-scan:grype-scan-metric-load-generator"
                        },
                        "grype-scan-load-control-client": {
                            sh "${bob} grype-scan:grype-scan-load-control-client"
                        },
                        "grype-scan-load-control-service": {
                            sh "${bob} grype-scan:grype-scan-load-control-service"
                        }
                )
            }
        }

        stage('Hadolint Scan') {
            steps {
                sh "${bob} hadolint-scan"
            }
        }
        stage('Kubeaudit Scan') {
            steps {
                sh "${bob} kubeaudit-scan"
            }
        }
        stage('Kubesec Scan') {
            steps {
                sh "${bob} kubesec-scan"
            }
        }
        stage('XRay Scan') {
            steps {
                sh "${bob} fetch-xray-report"
            }
        }
        stage('Generate VA Report') {
            steps {
                sh "${bob} generate-VA-report-V2"
            }
        }
    }
    post {
        success {
            script {
                sh '''
                    set +x
                    echo "success"
                '''
            }
        }
        failure {
           script {
               sh '''
                   echo "Failed"
               '''
           }
        }
        always {
            script {
                currentBuild.displayName = "#${BUILD_NUMBER} - Full"
            }
        }

    }
}

// More about @Builder: http://mrhaki.blogspot.com/2014/05/groovy-goodness-use-builder-ast.html
import groovy.transform.builder.Builder
import groovy.transform.builder.SimpleStrategy

@Builder(builderStrategy = SimpleStrategy, prefix = '')
class BobCommand {
    def bobImage = 'bob.2.0:latest'
    def envVars = [:]
    def needDockerSocket = false
    def rulesetFile = 'ruleset2.0.yaml'

    String toString() {
        def env = envVars
                .collect({ entry -> "-e ${entry.key}=\"${entry.value}\"" })
                .join(' ')

        def cmd = """\
            |docker run
            |--init
            |--rm
            |--workdir \${PWD}
            |--user \$(id -u):\$(id -g)
            |-v \${PWD}:\${PWD}
            |-v /home/enmadm100/doc_push/group:/etc/group:ro
            |-v /home/enmadm100/doc_push/passwd:/etc/passwd:ro
            |-v \${HOME}/.m2:\${HOME}/.m2
            |-v \${HOME}/.docker:\${HOME}/.docker
            |${needDockerSocket ? '-v /var/run/docker.sock:/var/run/docker.sock' : ''}
            |${env}
            |\$(for group in \$(id -G); do printf ' --group-add %s' "\$group"; done)
            |--group-add \$(stat -c '%g' /var/run/docker.sock)
            |${bobImage}
            |-r ${rulesetFile}
            |"""
        return cmd
                .stripMargin()           // remove indentation
                .replace('\n', ' ')      // join lines
                .replaceAll(/[ ]+/, ' ') // replace multiple spaces by one
    }
}
