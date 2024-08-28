# Load Testing Framework Setup

## Setting Up the Images

Before you can run the charts, you must build the relevant Docker images locally if you have not done so previously.

The Dockerfiles for the required images are located in:

- *eric-enm-cniv-dps-benchmark/docker/neo4j-populator*
- *eric-enm-cniv-dps-benchmark/docker/neo4j*

You can use the *eric-enm-cniv-dps-benchmark/utils/build_images.sh* script which will build them for you.

See also ***Testing with snapshot/local images*** below.

## Installing the Load Testing Framework on an Ericsson environment

This example outlines the steps required to install the load testing framework on the **Hoff_075** KaaS environment (namespace *enm11*),
as this is what has been available to us at the time of writing this guide.

**Note**: in order to run this on an Ericsson KaaS environment, you must push the relevant images that you have built locally to the Ericsson Docker
snapshot repository *proj-eric-oss-cniv-internal*.
Otherwise, the installation will fail as the images will not be accessible on the environment.

In addition, for any load types older than _ENM_23.11_Extra_Large_Cloud_Native_, use 'neo4j-load-profiles' instead of 'eric-neo4j-load-profiles' as
the image name within the values files - once these load types are replaced with newer ones, the name will need to also be updated in the
corresponding values file.

For more information on how to setup and use Kubernetes
see https://confluence-oss.seli.wh.rnd.internal.ericsson.com/display/TORFTDM/Installing+and+Using+Kubernetes.

### Installation

Use the charts to install all the required components (PVCs, Neo4j Populator, Services, Neo4j cluster, etc.).

```bash
$ helm install neo4j-load-testing-fwk eric-neo4j-load-test-fwk/ -n enm11
```

### Installation - with custom values

To install the charts with custom values, for example the test_values.yaml:

```bash
$ helm install neo4j-load-testing-fwk -f eric-neo4j-load-test-fwk/test_values.yaml eric-neo4j-load-test-fwk/ -n enm11
```

### Verifying the installation

You can verify that the installation has been successful by viewing the state of the charts' deployment:

```bash
$ helm list -n enm11
NAME                     NAMESPACE   REVISION   UPDATED   STATUS       CHART                           APP VERSION
neo4j-load-testing-fwk   enm11       1          <date>    deployed     eric-neo4j-load-test-fwk-0.1.0  <version>
```

and by checking the state of the Pods:

```bash
$ kubectl get pods -n enm11
NAME                         READY   STATUS      RESTARTS   AGE
neo4j-0                      1/1     Running     0          4m5s
neo4j-1                      1/1     Running     0          24s
neo4j-2                      1/1     Running     0          19s
neo4j-benchmarking-populator 0/1     Completed   0          4m5s
```

Execute into one of the Pods to verify that the Neo4j members have discovered each other and formed a cluster:

```bash
$ kubectl exec -it neo4j-0 -n enm11 -- /bin/bash
root@neo4j-0:/var/lib/neo4j# bin/cypher-shell -a neo4j://localhost:7687 "call dbms.cluster.overview();"
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| id                                     | addresses                                                                                                  | databases                             | groups |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| "99400cc9-7c8e-43fd-b4b2-00ca349f86f6" | ["bolt://neo4j-1.neo4j.enm11.svc.cluster.local:7687", "http://neo4j-1.neo4j.enm11.svc.cluster.local:7474"] | {dps: "FOLLOWER", system: "FOLLOWER"} | []     |
| "9b5178c6-c002-4717-9a92-49ef748bdaba" | ["bolt://neo4j-2.neo4j.enm11.svc.cluster.local:7687", "http://neo4j-2.neo4j.enm11.svc.cluster.local:7474"] | {dps: "FOLLOWER", system: "FOLLOWER"} | []     |
| "1ea3f05f-af1a-4f29-a120-f0014c239c3e" | ["bolt://neo4j-0.neo4j.enm11.svc.cluster.local:7687", "http://neo4j-0.neo4j.enm11.svc.cluster.local:7474"] | {dps: "LEADER", system: "LEADER"}     | []     |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

### Testing the installation

To execute chart-tests on the installed release:

```bash
$ helm test neo4j-load-testing-fwk -n enm11
```

### Uninstalling the charts

To uninstall the Load Testing Framework from the deployment run:

```bash
$ helm uninstall neo4j-load-testing-fwk -n enm11
```

## Installing the charts locally

If you have Kubernetes and Helm available on your machine, the process of installing the charts mentioned above is very similar
with a few subtle differences:

- Reduce the amount of resources required by each Pod in the StatefulSet - otherwise the Pods can fail to
  start (you can do this through modification of the values in the neo4j.requests values):

```
Events:
  Type     Reason            Age                 From               Message
  ----     ------            ----                ----               -------
  Warning  FailedScheduling  32s (x4 over 3m7s)  default-scheduler  0/1 nodes are available: 1 Insufficient cpu.
```

- Temporarily modify *eric-neo4j-load-test-fwk/charts/neo4j/templates/neo4j_volumes.yaml* with a local volumes configuration.
- Reduce the amount of objects to be created from the templates *eric-neo4j-load-test-fwk/charts/data-populator/templates/neo4j_configmap.yaml*
  as otherwise it will require a lot of disk space.
- (Optionally) run the Neo4j as a single instance server rather than a cluster.

Local versions of all relevant files are available in *benchmark_local*. You can overwrite the real files with these if you wish.

```bash
$ cp -r  benchmark_local/* eric-neo4j-load-test-fwk/.
```

There is also a values file for running locally which will use the local images you have built (*test_values_local*).

```bash
$ helm install neo4j-load-testing-fwk -f eric-neo4j-load-test-fwk/test_values_local.yaml eric-neo4j-load-test-fwk/ -n enm11
```

### Avoiding Re-population

As the population phase can take a very long time you can run the system so that the persistence volumes are
retained, the Neo4j service is kept running and the population phase is reduced on subsequent runs.

(Note that some work needs to be done by the population phase to reset changes done by previous load generators).

To do this, first start the Neo4j Service independently of the other charts:

```bash
$ helm install neo4j-load-testing-fwk-db [-f values_file] eric-neo4j-load-test-fwk/optional/eric-neo4j-load-test-fwk-neo4j -n <your_namespace_here>
```
Then in your values file ensure that persistent volumes are not rebuilt:

    global:
      neo4j:
        rebuild: false

This will also ensure that a full population will not be performed. 

You will also need to add the validation phase - otherwise the runtime types will not get validated before the second run. 

Do this by adding this to your values file:

    tags:
      validate: true

Start the main helm chart in the usual way, as outlined above. 

Now when you uninstall the main chart, the Neo4j instance(s) will still be running.

You can then re-run the main chart as required and a minimal population will run.

### Saving Metrics Between Runs

The default behaviour (when gathering of metrics is enabled) is to use temporary storage to store the prometheus data. 
So this is not ideal if you want to compare metrics for different runs of the load generators.

To get around this it is possible to use an independent persistent volume which will survive the shutting down of the rest of the load
generation system.

There is a helm chart defined which should be manually used to define the required persistent volume:

```bash
$ helm install prometheus-data eric-neo4j-load-test-fwk/optional/eric-neo4j-load-test-fwk-monitoring/optional/prometheus-volume -n <your_namespace_here>
```
Then in your values file ensure that prometheus persistent data is used:

    global:
      monitoring:
        metricsEnabled: true
        persistPrometheus: true

# Performing a point-fix
Occasionally we may need to patch an existing image version. The `PointfixPreCommit` and `Pointfix` files in the repository root directory
execute only the stages required to do so.

To apply a point-fix you must first identify the following:
- The version of the image you need to rebuild.
- The version of CBOS that this image has been based off originally.
- Any versions of our load-testing-framework JARs that the original image has been built with, so that we do not inadvertently perform a point-fix
by including newer software (unless that is required).

Modify the `build-pointfix` rule within ruleset2.0.yaml file as needed. For example, to build a pointfix on the load-test-framework's base image,
the rule should execute commands to build and push the desired version of **only** our base image.

```yaml
  build-pointfix:
    - task: build-pointfix
      cmd:
        - /bin/bash -c "cd ${var.work-dir}/docker_cniv/base && docker build . --build-arg='OS_BASE_IMAGE_TAG=yyyy'
           --build-arg='CREATED=${var.created}' --build-arg='COMMIT=${var.commithash}' --build-arg='APP_VERSION=xxxx' -t ${var.base-image-path}:xxxx"
        - docker push ${var.base-image-path}:${var.version}
```
Replace the `yyyy` in `OS_BASE_IMAGE_TAG=yyyy` with the relevant CBOS version.
Replace the `xxxx` `APP_VERSION=xxxx` and `${var.base-image-path}:xxxx` with the version of the image you want to rebuild.

For example, when point-fixing version `1.0.0-91` of our base image, `xxxx` becomes `1.0.0-91` and `yyyy` becomes `6.5.0-10`. You can check
the version of CBOS used while building the original image by running:

```bash
docker inspect armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-drop/dps-ltf:1.0.0-91
```

and checking the labels.

**Note**: when point-fixing versions before we have changed the image names (any version before 1.0.0-97), you will need to modify
`common-properties.yaml` and set the appropriate image name. E.g. in the case of this example, `1.0.0-91` was built before the name change,
so `eric-dps-ltf` has to be changed to `dps-ltf`.

To apply the point-fix, change the Jenkins files to be used by the pipeline, within the same branch as your other code changes. The simplest way to do this is:

```bash
mv JenkinsfilePreCommit OriginalJenkinsfilePreCommit
mv Jenkinsfile OriginalJenkinsfile

mv PointfixPreCommit JenkinsfilePreCommit
mv Pointfix Jenkinsfile
```

Once you merge and release the changes, immediately revert any of the pointfix related changes in a new branch and merge it in. E.g.

```bash
mv JenkinsfilePreCommit PointfixPreCommit
mv Jenkinsfile Pointfix

mv OriginalJenkinsfilePreCommit JenkinsfilePreCommit
mv OriginalJenkinsfile Jenkinsfile
```
