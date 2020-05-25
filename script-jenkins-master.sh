#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

mkdir /home/ubuntu/.aws
cp /tmp/config /home/ubuntu/.aws/

curl -sSL https://get.docker.com/ | sudo sh
sudo usermod -aG docker ubuntu



mkdir ~/jenkins
sudo chmod 777 -R ~/jenkins
cd ~/jenkins
docker pull jenkins/jenkins:lts
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v /home/ubuntu/jenkins:/var/jenkins_home --restart always jenkins/jenkins:lts
echo "sleep 60"
sleep 60
docker logs --tail 1000 jenkins