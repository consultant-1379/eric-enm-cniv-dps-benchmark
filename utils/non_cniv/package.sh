#!/bin/bash
set -x
set -e
# If used to build the images from local files it assumes all repos in a common directory
LOAD_GENERATOR_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../../../dps-tools/load-testing-framework"
DRIVER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../../../neo4j/neo4j-java-driver"

copy_lg() {
  copy_local "$1" "$2" "$3" "$LOAD_GENERATOR_ROOT"
}

copy_driver() {
  copy_local "$1" "$2" "$3" "$DRIVER_DIR"
}

copy_local() {
  num_matches=$(find "$4/$1/target/" -type f -name "$2" | wc -l)
  if [ "$num_matches" -eq 1 ] ; then
    echo "Copying $3 from $1"
    find "$4/$1/target/" -type f -name "$2" -exec cp {} "$3" \;
    return 0
  else
    echo "$num_matches found for $3 - aborting build"
    return 1
  fi
}

BUILD_MODE="RELEASE"
if [ -n "$1" ]; then
  if [[ "$1" == "-latest" ]]; then
    BUILD_MODE="LATEST"
  else
    echo "Unknown arguments - will build from latest released versions"
  fi
fi
mkdir ../../output
cd ../../output || (echo "Failed to create output directory" && exit)

mkdir lib
mkdir docker
mkdir helm

cp -r ../docker_non_cniv/. docker/
cp -r ../docker_cniv/neo4j-load-profiles/data/. docker/neo4j-load-profiles/data/
cp -r ../eric-neo4j-load-test-fwk/charts helm/
cp ../eric-neo4j-load-test-fwk/standalone_values.yaml helm/standalone_values.yaml
cp ../eric-neo4j-load-test-fwk/Chart.yaml helm/Chart.yaml

cd docker/neo4j-load-profiles/data || (echo "Failed to find neo4j-load-profiles/data directory" && exit)
unzip load.zip
unzip templates.zip
cd ../../..

cd lib || (echo "Failed to find lib directory" && exit)

if [[ "$BUILD_MODE" == "RELEASE" ]]; then
  echo "Building from latest released versions"
  curl -L -o load-testing-control-client.jar "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=load-testing-control-client&v=RELEASE&c=shaded"
  curl -L -o load-testing-control-service.jar "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=load-testing-control-service&v=RELEASE&c=exec"
  curl -L -o metric-load-generator.jar "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=metric-load-generator&v=RELEASE&c=exec"
  curl -L -o neo4j-java-driver-transport-bolt-extension.jar "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps.3pp&a=neo4j-java-driver-transport-bolt-extension&v=RELEASE&c=shaded"
  curl -L -o load-testing-control-plugin.jar "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=load-testing-control-plugin&v=RELEASE&c=shaded"
  curl -L -o neo4j-data-populator.tar.gz "https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/artifact/maven/redirect?r=releases&g=com.ericsson.oss.itpf.datalayer.dps&a=neo4j-data-populator&v=RELEASE&e=tar.gz&c=package"
else
  echo "Building from latest local versions - ensure you have everything built!"
  copy_lg "load-testing-control/load-testing-control-client" "load-testing-control-client-*-shaded.jar" "load-testing-control-client.jar"
  copy_lg "load-testing-control/load-testing-control-service" "load-testing-control-service-*-exec.jar" "load-testing-control-service.jar"
  copy_lg "metric-load-generator" "metric-load-generator-*-exec.jar" "metric-load-generator.jar"
  copy_driver "transport/transport-bolt-extension" "neo4j-java-driver-transport-bolt-extension-*-shaded.jar" "neo4j-java-driver-transport-bolt-extension.jar"
  copy_lg "load-testing-control/load-testing-control-plugin" "load-testing-control-plugin-*-shaded.jar" "load-testing-control-plugin.jar"
  copy_lg "neo4j-data-populator" "neo4j-data-populator-*-package.tar.gz" "neo4j-data-populator.tar.gz"
fi

cd ..

cp ../README_non_cniv.md README.md
cp ../utils/non_cniv/build_images.sh build_images.sh
cp ../utils/non_cniv/build_local.sh build_local.sh
cp ../utils/non_cniv/tag_and_push.sh tag_and_push.sh
chmod +x build_images.sh
chmod +x build_local.sh
chmod +x tag_and_push.sh