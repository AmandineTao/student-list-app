#!/bin/bash

git clone https://github.com/diranetafen/student-list.git

cd student-list/simple_api/

docker build -t api-pozos:1 .

docker images

## Test manually
# docker network create pozos

# docker network ls

# docker ps

# docker run -d --network pozos --name test-api-pozos -v ${PWD}/student_age.json:/data/student_age.json  -p 5001:5000 api-pozos:1

# curl -u toto:python -X GET http://10.0.1.3:5001/pozos/api/v1.0/get_student_ages

## test app with docker compose 
cd ../

docker compose up -d
docker-compose ps
docker network ls
docker-compose ps
chmod 777 website/index.php
#   ----update line 30 of website/index.php with "$url = 'http://student-list-api-pozos-1:5000/pozos/api/v1.0/get_student_ages'"
#actualiser la fenetre de l'appli ouverte sur le port 8081

#### deploy app on docker registry

# creer le registre docker (conteneur)
docker run -d -p 5000:5000 --name registry-pozos --network student-list_api-pozos-network registry:2
docker ps -a

# tager l'image 
docker images
docker image tag api-pozos:1 localhost:5000/api-pozos:1

docker image tag api-pozos:1 registry-pozos:5000/api-pozos:1

# push images
docker images
docker push localhost:5000/api-pozos:1
docker push registry-pozos:5000/api-pozos:1

# create the container for ihm
docker run -d  --name registry-pozos_ihm_ui --network student-list_api-pozos-network -p 4002:80 -e REGISTRY_TITLE="POZOS REGISTRY" -e REGISTRY_URL=http://registry-pozos:5000 -e DELETE_IMAGES=true joxit/docker-registry-ui:static

# tag the image joxit/docker-registry-ui:static and push its new tag
docker image tag joxit/docker-registry-ui:static localhost:5000/joxit/docker-registry-ui:static
docker push localhost:5000/joxit/docker-registry-ui:static
