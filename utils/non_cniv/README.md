## Usage

Running the package.sh script will copy/download all the required artifacts into an output directory.

When that has been done, see the generated README file which instructs on how to build, tag, push etc.

Using that script without parameters will build the package using the latest RELEASED versions of the relevant software. But there are other options, see next section.

### Testing with snapshot/local images

If you want to test with local images there are a number of steps to follow:

1. Firstly ensure that all required repos (eric-enm-cniv-dps-benchmark, dps-tools and neo4j [enm version]) are in the same directory.

2. (Optional) Ensure you have copied the versions of the load and template zip files into docker_cniv/neo4j-load-profiles/data if you want to use a specific load profile. (Required data can be found at https://eteamspace.internal.ericsson.com/display/TORFTDM/Load+Profile+Images)

3. Then build all the modules in dps-tools/load-testing-framework (mvn install will suffice).

4. Now run the 'package.sh' script with a '-latest' option defined.
