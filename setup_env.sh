#!/bin/bash
export REGION=eu-central-1
export REPOSITORY_NAME=swit3k/zupa-backend
export PATH=~/.local/bin:$PATH

export PATH=$PATH

export TASKS_DIR=$SCRIPTS_DIR/tasks

export CLUSTER=default

export REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | tr -d '"'`
