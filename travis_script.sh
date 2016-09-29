docker pull bgruening/galaxy-stable:latest
docker pull manabuishii/docker-sge-master:0.1.0
docker pull manabuishii/docker-bioblend:0.8.0

# start master
docker run --hostname sgemaster --name sgemaster -d -v $PWD/master_script.sh:/usr/local/bin/master_script.sh  manabuishii/docker-sge-master:0.1.0 /usr/local/bin/master_script.sh
# wait to sge master
sleep 10

# start galaxy
GALAXY_CONTAINER=bgruening/galaxy-stable:latest
GALAXY_CONTAINER_NAME=galaxytest
GALAXY_CONTAINER_HOSTNAME=galaxytest

docker run -d \
           --link sgemaster:sgemaster \
           --name ${GALAXY_CONTAINER_NAME} \
           --hostname ${GALAXY_CONTAINER_HOSTNAME} \
           -p 20080:80  -e NONUSE="condor" \
           -v $PWD/job_conf.xml.local:/etc/galaxy/job_conf.xml \
           -v $PWD/export:/export \
           -v $PWD/outputhostname:/galaxy-central/tools/outputhostname \
           -v $PWD/outputhostname.tool.xml:/galaxy-central/outputhostname.tool.xml \
           -v $PWD/setup_tool.sh:/galaxy-central/setup_tool.sh \
           -v $PWD/tool_conf.xml:/galaxy-central/tool_conf.xml \
           -v $PWD/act_qmaster:/var/lib/gridengine/default/common/act_qmaster \
           ${GALAXY_CONTAINER} \
           /galaxy-central/setup_tool.sh
echo "Wait 10sec"
sleep 10

# Add host setting galaxytest to sgemaster
SGECLIENT=$(docker exec ${GALAXY_CONTAINER_NAME} cat /etc/hosts | grep ${GALAXY_CONTAINER_HOSTNAME})
docker exec sgemaster bash -c "echo ${SGECLIENT} >> /etc/hosts"
# Add gridengine client host
docker exec sgemaster qconf -as ${GALAXY_CONTAINER_HOSTNAME} 

docker run --rm  --link galaxytest:galaxytest -v $PWD/test_outputhostname.py:/work/test_outputhostname.py manabuishii/docker-bioblend:0.8.0 python /work/test_outputhostname.py > out
grep galaxytest out
RET=$?
exit $RET
