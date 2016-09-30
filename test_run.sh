docker stop sgemaster
docker rm sgemaster
docker stop galaxytest
docker rm galaxytest
sudo rm -rf export

# run same script on travis
./travis_script.sh
