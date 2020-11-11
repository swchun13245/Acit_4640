Vagrant.configure("2") do |config|
  config.vm.box = "4640BOX"

  config.ssh.username = "admin"
  config.ssh.private_key_path = "./acit_admin_id_rsa"

  config.vm.synced_folder "./shared", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.linked_clone = true
  end

  config.vm.provision "file", source: "./ansible", destination: "/home/admin/ansible"
  
  config.vm.define "todohttp" do |todohttp|
    todohttp.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_HTTP_4640"
        vb.memory = 2048
    end
    todohttp.vm.network "private_network", "ip": "192.168.150.30"
    todohttp.vm.network "forwarded_port", guest: 80, host: 8888
    todohttp.vm.provision "ansible_local" do |ansible|
        ansible.provisioning_path = "/home/admin/ansible"
        ansible.playbook = "/home/admin/ansible/nginx.yaml"
    end
    todohttp.vm.hostname = "tododb.bcit.local"
  end

  config.vm.define "tododb" do |tododb|
    tododb.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_DB_4640"
        vb.memory = 2048
    end
    tododb.vm.network "private_network", "ip": "192.168.150.20"
    tododb.vm.provision "ansible_local" do |ansible|
        ansible.provisioning_path = "/home/admin/ansible"
        ansible.playbook = "/home/admin/ansible/database.yaml"
    end
    tododb.vm.hostname = "tododb.bcit.local"
  end

  config.vm.define "todoapp" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_APP_4640"
        vb.memory = 2048
    end
    todoapp.vm.network "private_network", "ip": "192.168.150.10"
    todoapp.vm.provision "ansible_local" do |ansible|
        ansible.provisioning_path = "/home/admin/ansible"
        ansible.playbook = "/home/admin/ansible/app.yaml"
    end
    todoapp.vm.hostname = "todoapp.bcit.local"
  end
end