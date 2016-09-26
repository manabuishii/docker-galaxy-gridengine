docker pull bgruening/galaxy-stable:latest
docker pull manabuishii/docker-sge-master:0.1.0

# start master
docker run --hostname sgemaster --name sgemaster -d -v $PWD/master_script.sh:/usr/local/bin/master_script.sh  manabuishii/docker-sge-master:0.1.0 /usr/local/bin/master_script.sh
# wait to sge master
sleep 10

# start galaxy
GALAXY_CONTAINER=bgruening/galaxy-stable:latest
GALAXY_CONTAINER_NAME=galaxytest
GALAXY_CONTAINER_HOSTNAME=galaxytest

docker run -d \
           --link sgemaster:sgemaster
           --name ${GALAXY_CONTAINER_NAME} \
           --hostname ${GALAXY_CONTAINER_HOSTNAME} \
           -p 80:80  -e NONUSE="condor" \
           -v $PWD/job_conf.xml.local:/etc/galaxy/job_conf.xml \
           -v $PWD/export:/export \
           -v $PWD/setup.sh:/galaxy-central/setup.sh \
           ${GALAXY_CONTAINER} 
sleep 10

