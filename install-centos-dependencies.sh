

# install dependencies
sudo yum -y install git wget epel-release rh-python36 python3-pip
virtualenv py3-ansible
source ./bin/activate
sudo pip3 install --upgrade virtualenv setuptools ansible jmespath
curl -fsSL https://get.docker.com/ | sh

# install inspec
wget https://packages.chef.io/files/stable/inspec/4.18.39/el/7/inspec-4.18.39-1.el7.x86_64.rpm
sudo yum -y localinstall inspec-4.18.39-1.el7.x86_64.rpm
