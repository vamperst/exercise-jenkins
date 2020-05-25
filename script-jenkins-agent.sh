#!/bin/bash

mkdir /home/ubuntu/.aws
cp /tmp/config /home/ubuntu/.aws/

curl -sSL https://get.docker.com/ | sudo sh

sudo usermod -aG docker ubuntu

sudo apt install openjdk-8-jdk -y
# Download Jenkins Swarm Client
sudo mkdir -p /usr/local/jenkins
cd /usr/local/jenkins
sudo curl -L https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.7/swarm-client-3.7.jar -o swarm-client-3.7.jar 
echo "swarm-client-3.7.jar downloaded"
ls -lha
sudo touch swarm.sh
sudo chmod +x swarm.sh

sudo truncate -s0 /usr/local/jenkins/swarm.sh

sudo cat >> /usr/local/jenkins/swarm.sh <<EOL
#!/bin/bash
cd /usr/local/jenkins

java -jar swarm-client-3.7.jar -name "$(hostname)" -executors 8 -labels docker -master "http://ip_master:8080" -username "USERNAME" -password "PASSWORD" -fsroot /tmp
EOL

sudo cat >> /etc/systemd/system/jenkins.service <<EOL
[Unit]
Description=Jenkins
After=network.target

[Service]
User=ubuntu
Restart=always
Type=simple
ExecStart=/usr/local/jenkins/swarm.sh

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable jenkins
sudo systemctl start jenkins

cd /usr/local/bin
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://github.com/tsenart/vegeta/releases/download/v6.3.0/vegeta-v6.3.0-linux-amd64.tar.gz -o vegeta-v6.3.0-linux-amd64.tar.gz
sudo tar xf *.gz
sudo rm *.gz


