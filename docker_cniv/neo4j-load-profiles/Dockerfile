ARG BASE_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-eric-oss-cniv/proj-eric-oss-cniv-ci-internal
ARG BASE_IMAGE_NAME=eric-dps-ltf
ARG BASE_IMAGE_TAG=latest

FROM $BASE_IMAGE_REPO/${BASE_IMAGE_NAME}:$BASE_IMAGE_TAG

USER root
WORKDIR /populator

# Expected format of the the zipped data:
# load.zip:
# load/
#   - as_is/
#       .txt *n
#   - cache_data/
#       queryCache.log
#
# templates.zip:
# templates/
#   - release/
#       .10n *n
#   - another_release/
#       .10n *n

# Expecting build context to point to this directory
COPY data/load.zip ./temp/
COPY data/templates.zip ./temp/
COPY validate_image_structure.sh ./temp/


RUN zypper install -y 'unzip>=6.00' && zypper clean && unzip ./temp/load.zip && unzip ./temp/templates.zip && sed -i 's/\r$//' ./temp/validate_image_structure.sh \
    && chmod u+x ./temp/validate_image_structure.sh && ./temp/validate_image_structure.sh

USER $USER_ID