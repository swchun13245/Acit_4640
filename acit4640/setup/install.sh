sudo setenforce 0
sudo cp setup/selinux_config /etc/selinux/config
sudo useradd todoapp
sudo dnf install -y git
sudo -u todoapp bash -c 'cd /home/todoapp; git clone https://github.com/timoguic/ACIT4640-todo-app.git app'
sudo dnf search nodejs
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo dnf install -y nodejs
sudo dnf search mongo
sudo cp setup/mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo
sudo dnf install -y mongodb-org
sudo cp setup/database.js /home/todoapp/app/config/database.js
sudo -i sh -c 'systemctl start mongod;'
sudo su - todoapp sh -c 'cd /home/todoapp/app; npm install;'
sudo -i sh -c 'firewall-cmd --zone=public --add-port=8080/tcp;'
sudo -i sh -c 'firewall-cmd --zone=public --add-port=80/tcp;'
sudo -i sh -c 'firewall-cmd --zone=public --add-service=http;'
sudo -i sh -c 'firewall-cmd --runtime-to-permanent;'
sudo cp setup/todoapp.service /etc/systemd/system/todoapp.service
sudo -i sh -c 'systemctl daemon-reload;'
sudo -i sh -c 'systemctl enable todoapp;'
sudo -i sh -c 'systemctl start todoapp;'
sudo -i sh -c 'dnf install -y epel-release;'
sudo -i sh -c 'dnf install -y nginx;'
sudo -i sh -c 'systemctl enable nginx;'
sudo -i sh -c 'systemctl start nginx;'
sudo cp setup/nginx.conf /etc/nginx/nginx.conf
sudo -u todoapp sh -c 'cd /home; chmod a+rx todoapp;'
sudo -i sh -c 'systemctl restart nginx;'

