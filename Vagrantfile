# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb, override|
    override.vm.box = "oddedev"
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get install -y python python-pip \
        python-dev python-apt python-mysqldb
    pip install ansible

    # 安装一个特定版本的 ansible
    pip install ansible==2.3.1.0

    # 有一些 module 可能需要特定的软件包
    apt-get install -y ca-certificates python python-pip libssl-dev sudo git curl \
                   python-httplib2 python-keyczar python-setuptools \
                   python-pkg-resources python-mysqldb \
                   python-dev libffi-dev
                   
    cd /vagrant
    ansible-playbook --inventory hosts.txt bbuddy.yml
  SHELL
end