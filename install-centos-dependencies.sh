

# install dependencies
sudo yum -y install git wget epel-release centos-release-scl rh-python36 python3-pip ansible
scl enable rh-python36 bash
sudo pip3 install --upgrade setuptools jmespath
curl -fsSL https://get.docker.com/ | sh

# install inspec
wget https://packages.chef.io/files/stable/inspec/4.18.39/el/7/inspec-4.18.39-1.el7.x86_64.rpm
sudo yum -y localinstall inspec-4.18.39-1.el7.x86_64.rpm
