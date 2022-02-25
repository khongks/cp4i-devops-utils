#!/bin/bash

# Upload BAR file to Artifactory

ARTIFACTORY_HOST=$1
ARTIFACTORY_REPO=$2
ARTIFACTORY_BASE_PATH=$3
ARTIFACTORY_BAR_FILE=$4
ARTIFACTORY_USER=$5
ARTIFACTORY_PASSWORD=$6

CHECKSUM=`shasum -a 1 $ARTIFACTORY_BAR_FILE | awk '{ print $1 }'`

echo "curl -kv --user $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD -H 'X-Checksum-Sha1:${CHECKSUM}' -T $ARTIFACTORY_BAR_FILE -X PUT https://$ARTIFACTORY_HOST/artifactory/$ARTIFACTORY_REPO/$ARTIFACTORY_BASE_PATH/$ARTIFACTORY_BAR_FILE"
curl -kv --user $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD -H "X-Checksum-Sha1:${CHECKSUM}" -T $ARTIFACTORY_BAR_FILE -X PUT https://$ARTIFACTORY_HOST/artifactory/$ARTIFACTORY_REPO/$ARTIFACTORY_BASE_PATH/$ARTIFACTORY_BAR_FILE
