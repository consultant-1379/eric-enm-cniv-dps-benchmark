#!/bin/bash

# Accepts two image names as input. The first image is always considered the "remote" one against which the second, "local" image is to be compared.
# The script pulls the remote image - if such image does not exist, the script exits successfully as there is nothing to check. Else, if a remote image
# is found, the contents of both images are temporarily exported into a tarball. A checksum is calculated based on the file sizes and names within
# "populator/load" of the two images. If the two checksums are equal, the script exits successfully. Otherwise, the script exits with a failure.

FIRST_IMAGE=$1
SECOND_IMAGE=$2

function export_image_checksum() {
  docker create $1 | {
    read cid
    docker export $cid | tar -tv | grep 'populator/load' | awk '{ print $3, $6}' | sha256sum
    docker rm $cid > /dev/null
  } > checksum.txt
  checksum=$(cat checksum.txt)
  rm -f checksum.txt
}

function compare_images() {
  export_image_checksum $FIRST_IMAGE
  first_checksum=$checksum
  export_image_checksum $SECOND_IMAGE
  second_checksum=$checksum

  echo "$FIRST_IMAGE = $first_checksum"
  echo "$SECOND_IMAGE = $second_checksum"

  if [[ "$first_checksum" == "$second_checksum" ]]; then
      echo "Images are equal"
      exit 0
  else
      echo "Images are not equal"
      exit 1
  fi
}

docker pull $1 > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "An image with this tag has not been pushed yet. Nothing to check."
  exit 0
else
  echo "Pulled $1"
  compare_images
fi