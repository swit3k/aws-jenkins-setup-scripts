#!/bin/bash
echo 'Repository URI:' $REPOSITORY_URI ', BUILD #' $BUILD_NUMBER
docker push ${REPOSITORY_URI}:v${BUILD_NUMBER}
