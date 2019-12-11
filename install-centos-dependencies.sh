

# install dependencies
sudo yum -y install git wget epel-release ansible
sudo subscription-manager repos --enable rhel-7-server-ansible-2.9-rpms
sudo pip install jmespath
curl -fsSL https://get.docker.com/ | sh

# install inspec
wget https://packages.chef.io/files/stable/inspec/4.18.39/el/7/inspec-4.18.39-1.el7.x86_64.rpm
sudo yum localinstall inspec-4.18.39-1.el7.x86_64.rpm
