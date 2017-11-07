#!/bin/bash
DOCKER_LOGIN=`aws ecr get-login --no-include-email --region eu-central-1 --registry-ids 616657797484`
${DOCKER_LOGIN}
