# start galaxy
sudo rm -rf export
GALAXY_CONTAINER=bgruening/galaxy-stable:latest
GALAXY_CONTAINER_NAME=galaxytest
GALAXY_CONTAINER_HOSTNAME=galaxytest

docker run -ti \
           --name ${GALAXY_CONTAINER_NAME} \
           --hostname ${GALAXY_CONTAINER_HOSTNAME} \
           -p 29002:9002 -p 20080:80  -e NONUSE="condor" \
           -v $PWD/job_conf.xml.local:/etc/galaxy/job_conf.xml \
           -v $PWD/export:/export \
           -v $PWD/outputhostname:/galaxy-central/tools/outputhostname \
           -v $PWD/outputhostname.tool.xml:/galaxy-central/outputhostname.tool.xml \
           -v $PWD/tool_conf.xml:/galaxy-central/tool_conf.xml \
           -v $PWD/setup_tool.sh:/galaxy-central/setup_tool.sh \
           -v $PWD/act_qmaster:/var/lib/gridengine/default/common/act_qmaster \
           ${GALAXY_CONTAINER} \
           /galaxy-central/setup_tool.sh
docker stop ${GALAXY_CONTAINER_NAME}
docker rm ${GALAXY_CONTAINER_NAME}
