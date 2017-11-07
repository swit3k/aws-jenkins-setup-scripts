#!/bin/bash
#Constants

TASKDEF_LOCATION=$SCRIPTS_DIR/taskdef.json
FAMILY=`sed -n 's/.*"family": "\(.*\)",/\1/p' $TASKDEF_LOCATION`
NAME=`sed -n 's/.*"name": "\(.*\)",/\1/p' $TASKDEF_LOCATION`
SERVICE_NAME=${NAME}-service
DESIRED_COUNT=1

#Replace the build number and respository URI placeholders with the constants above
TASK_FILE=${NAME}-v${BUILD_NUMBER}.json 
#sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" -e "s;%REPOSITORY_URI%;${REPOSITORY_URI};g" $TASKDEF_LOCATION > $TASKS_DIR/$TASK_FILE 
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" -e "s;%REPOSITORY_URI%;${REPOSITORY_URI};g" $TASKDEF_LOCATION > $TASK_FILE 

#cp $TASKS_DIR/$TASK_FILE ${WORKSPACE}

#Register the task definition in the repository
aws ecs register-task-definition --family ${FAMILY} --cli-input-json "file://${WORKSPACE}/${TASK_FILE}" --region ${REGION}

#Get latest revision
REVISION=`aws ecs describe-task-definition --task-definition ${FAMILY} --region ${REGION} | jq .taskDefinition.revision`
echo "AWS TASK REVISION: ${REVISION}"

SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]`

if [ "$SERVICES" == "" ]; then
  echo "entered existing service"
  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT} | jq .taskDefinition.status
else
  echo "entered new service"
  aws ecs create-service --service-name ${SERVICE_NAME} --desired-count ${DESIRED_COUNT} --task-definition ${FAMILY} --cluster ${CLUSTER} --region ${REGION} | jq .taskDefinition.status
fi
