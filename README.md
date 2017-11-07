# aws-jenkins-setup-scripts
Scripts supporting Jenkins' build

## docker_login.sh
It sets correct Docker's registry by loggin in

## docker_push.sh
Pushes Docker image to ECR (AWS Container Registry)

## deploy.sh
Creates a new task definition, alters it by providing correct variables like ${BUILD_NUMBER}.
Next, it updates ECS (AWS Container Service) by providing newly created task definition.

## Flow
Local dev. env. -> Jenkins -> ECR -> ECS
