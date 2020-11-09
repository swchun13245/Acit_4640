
Vagrant.configure("2") do |config|
  config.vm.box = "4640BOX"
  config.ssh.username = "admin"
  config.ssh.private_key_path = "files/acit_admin_id_rsa"
  
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "todohttp" do |todohttp|
    todohttp.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_HTTP_4640"
        vb.memory = 2048
        vb.linked_clone = true
    end
    todohttp.vm.hostname = "todohttp.bcit.local"
    todohttp.vm.network "private_network", ip: "192.168.150.30"
    todohttp.vm.network "forwarded_port", guest: 80, host: 8888
    todohttp.vm.provision "file", source: "files/nginx.conf", destination: "/tmp/nginx.conf"
    todohttp.vm.provision "file", source: "files/todoapp_setup.sh", destination: "/tmp/install.sh"

    todohttp.vm.provision "shell", inline: <<-SHELL
    dnf install -y nginx
    dnf install -y git
    dnf install -y nodejs
    useradd todoapp
    sudo -u todoapp bash /tmp/install.sh
    mv /tmp/nginx.conf /etc/nginx/nginx.conf
    systemctl daemon-reload
    systemctl enable nginx
    systemctl restart nginx
  
  SHELL
  
  end
  
  config.vm.define "tododb" do |tododb|
    tododb.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_DB_4640"
        vb.memory = 2048
        vb.linked_clone = true
    end
    tododb.vm.hostname = "tododb.bcit.local"
    tododb.vm.network "private_network", ip: "192.168.150.20"
    tododb.vm.provision "file", source: "files/mongodbrepo.conf", destination: "/tmp/mongodbrepo.conf"
    tododb.vm.provision "file", source: "files/mongodb_ACIT4640.tgz", destination: "/tmp/mongodb.tgz"

    tododb.vm.provision "shell", inline: <<-SHELL
    mv /tmp/mongodbrepo.conf /etc/yum.repos.d/mongodb-org-4.4.repo
    dnf install -y mongodb-org tar
    
    sed -r -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
    
    firewall-cmd --zone=public --add-port=27017/tcp
    firewall-cmd --runtime-to-permanent
    
    systemctl daemon-reload
    systemctl enable mongod
    systemctl restart mongod

    mv /tmp/mongodb.tgz .
    tar zxvf mongodb.tgz
    export LANG=C.
    mongorestore -d acit4640 ACIT4640

  SHELL
  
  end

  config.vm.define "todoapp" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_APP_4640"
        vb.memory = 2048
        vb.linked_clone = true
    end
    todoapp.vm.hostname = "todoapp.bcit.local"
    todoapp.vm.network "private_network", ip: "192.168.150.10"
    todoapp.vm.provision "file", source: "files/todoapp.service", destination: "/tmp/todoapp.service"
    todoapp.vm.provision "file", source: "files/todoapp_setup.sh", destination: "/tmp/install.sh"
    todoapp.vm.provision "file", source: "files/database.js", destination: "/tmp/database.js"
    todoapp.vm.provision "shell", inline: <<-SHELL
      firewall-cmd --zone=public --add-port=8080/tcp
      firewall-cmd --runtime-to-permanent  

      curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
      dnf install -y nodejs git
      
      useradd todoapp
      sudo -u todoapp bash /tmp/install.sh
      
      mv /tmp/todoapp.service /etc/systemd/system/todoapp.service
      mv /tmp/database.js /home/todoapp/app/config/database.js

      systemctl daemon-reload
      systemctl enable todoapp
      systemctl restart todoapp
    SHELL
  end
  
end
