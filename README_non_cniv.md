# Load Testing Framework Setup

## Setting Up the Images

Before you can run the charts, you must build the relevant Docker images locally if you have not done so previously.

The Dockerfiles for the required images are located in:

- *docker/*

You can use the *build_images.sh* script which will build them for you.

Once the images are built, you must tag and push them to a private internal repository. You can use the *tag_and_push.sh* script for this. The script takes two parameters, the registry URL and the repository name. The script will tag and push the necessary images with the *standalone* tag.
```bash
$ ./tag_and_push.sh <registry_url> <repo_name>
```
If local is used as the registry URL then pushing will not be performed and the images used will be exclusive to your local repository.

Once that is done, you must edit the relevant *values.yaml* file to include your registry url and repository name, as well as the standalone tag if necessary.

See also ***Testing with snapshot/local images*** below.

## Installing the Load Testing Framework on an environment

Once the Docker images are built, you can use Helm to deploy the framework.

### Installation

Use the charts to install all the required components (PVCs, Neo4j Populator, Services, Neo4j cluster, etc.).

```bash
$ helm install neo4j-load-testing-fwk -f eric-neo4j-load-test-fwk/standalone_values.yaml eric-neo4j-load-test-fwk/ -n <your_namespace_here>
```

### Installation - with custom values

To install the charts with custom values, simply edit the standalone_values.yaml file, or create a duplicate, edit the values of the duplicate, and pass it as the file.

```bash
$ helm install neo4j-load-testing-fwk -f eric-neo4j-load-test-fwk/standalone_values_2.yaml eric-neo4j-load-test-fwk/ -n <your_namespace_here>
```

### Using custom Neo4j version

To use a custom Neo4j version, edit the Neo4j version in the _neo4j_ and _neo4j-populator_ Dockerfiles.

```dockerfile
FROM neo4j:<version>-enterprise
```

### Verifying the installation

You can verify that the installation has been successful by viewing the state of the charts' deployment:

```bash
$ helm list -n <your_namespace_here>
NAME                     NAMESPACE   REVISION   UPDATED   STATUS       CHART                           APP VERSION
neo4j-load-testing-fwk   enm11       1          <date>    deployed     eric-neo4j-load-test-fwk-0.1.0  <version>
```

and by checking the state of the Pods:

```bash
$ kubectl get pods -n <your_namespace_here>
NAME                         READY   STATUS      RESTARTS   AGE
neo4j-0                      1/1     Running     0          4m5s
neo4j-1                      1/1     Running     0          24s
neo4j-2                      1/1     Running     0          19s
neo4j-benchmarking-populator 0/1     Completed   0          4m5s
```

Execute into one of the Pods to verify that the Neo4j members have discovered each other and formed a cluster:

```bash
$ kubectl exec -it neo4j-0 -n <your_namespace_here> -- /bin/bash
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
$ helm test neo4j-load-testing-fwk -n <your_namespace_here>
```

### Uninstalling the charts

To uninstall the Load Testing Framework from the deployment run:

```bash
$ helm uninstall neo4j-load-testing-fwk -n <your_namespace_here>
```