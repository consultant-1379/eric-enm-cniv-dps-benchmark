#!/bin/sh

PROFILES_DIR="/populator/load/as_is"
CACHE_DATA_DIR="/populator/load/cache_data"
TEMPLATES_DIR="/populator/templates"

function verify_directory_exists() {
    if [ -d "$1" ]; then
        echo "'$1' exists as expected."
    else
        echo "The directory '$1' does not exist!"
        exit 1
    fi
}

function verify_directory_contains_data() {
    if [ $(ls -A "$1" | wc -l) -gt 0 ]; then
        echo "'$1' contains data as expected."
    else
        echo "The directory '$1' is empty!"
        exit 1
    fi
}

verify_directory_exists $PROFILES_DIR
verify_directory_exists $CACHE_DATA_DIR
verify_directory_exists $TEMPLATES_DIR
verify_directory_contains_data $PROFILES_DIR
verify_directory_contains_data $CACHE_DATA_DIR
verify_directory_contains_data $TEMPLATES_DIR
exit 0