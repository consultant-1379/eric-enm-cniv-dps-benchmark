ARG OS_BASE_IMAGE_NAME=sles
ARG OS_BASE_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-ldc/common_base_os_release
ARG OS_BASE_IMAGE_TAG=6.3.0-13

FROM ${OS_BASE_IMAGE_REPO}/${OS_BASE_IMAGE_NAME}:${OS_BASE_IMAGE_TAG}

ARG CREATED
ARG COMMIT
ARG APP_VERSION

ENV USER_ID=10001
ENV USER_NAME="DPS"

# LTF's product number is 'APR 201 973', but the DR checker expects it to begin with CXU or CXC
LABEL com.ericsson.product-number="CXU 101 0001" \
      org.opencontainers.image.title="Load Testing Framework" \
      org.opencontainers.image.created=${CREATED} \
      org.opencontainers.image.revision=${COMMIT} \
      org.opencontainers.image.vendor="Ericsson" \
      org.opencontainers.image.version=${APP_VERSION}

ARG CBOS_REPO=arm.sero.gic.ericsson.se/artifactory/proj-ldc-repo-rpm-local/common_base_os/sles
ARG OS_BASE_IMAGE_TAG

RUN zypper addrepo --gpgcheck-strict -f https://${CBOS_REPO}/${OS_BASE_IMAGE_TAG} COMMON_BASE_OS_SLES_REPO \
    && zypper --gpg-auto-import-keys refresh \
    && zypper install -y 'curl>=8.0.0' \
    && zypper install -y 'wget>=1.20.3' \
    && zypper install -y 'java-11-openjdk>=11.0.21.0' \
    && zypper clean \
    && echo "$USER_NAME:x:$USER_ID:$USER_ID::/nonexistent:/bin/false" >>/etc/passwd \
    && echo "$USER_NAME:!:0::::::" >>/etc/shadow

USER $USER_ID