# ansible-uber-demo
A comprehensive demonstration Ansible-based solution to quickly build and deploy an application in a public cloud using F5 and NGINX technology

## Featuring
- Grafana
- Kafka w/Zookeeper
- [Juice Shop app](https://hub.docker.com/r/bkimminich/juice-shop/)

## Dependencies
- Ansible 2.8

## Prerequisites
- This demo assumes an Ansible and Docker host of Ubuntu 18.04 (Bionic)

```
docker run --rm -it willhallonline/ansible:2.8-ubuntu-18.04 /bin/sh
```

- The Ubuntu server must be able to connect to your specified BIG-IP

```
inspec exec demo-setup -t docker://[docker container id]
```

- The BIG-IP must already be configured with a management address, and must already have an admin account password set. See [these instructions](https://support.f5.com/csp/article/K13121) for setting the admin password on BIG-IP.

## Usage
- ssh into your Ubuntu 18.04 docker container and execute the following:
    - `git clone https://github.com/aknot242/ansible-uber-demo.git`
    - `cd ansible-uber-demo`
    - `./install-ubuntu-dependencies.sh`. This will install the linux dependencies required to run Docker and Ansible.
    - `./deploy.sh`. This will run the Ansible playbook to configure everything.

## TODO:

1. Git pull Ansible workbooks
2. Build Ubuntu host (to run ansible and host containers) with...Ansible?
3. Build BIG-IPs
    1. Install DO
    2. Install AS3
    3. Install TS
4. Build containers
    1. Grafana
        1. API call to install GeoLocation map plugin
        2. API call to add alert channel (Teams?)
        3. API call to add datasources
        4. API call to import JSON dashboard
    3. Kafka & Zookeeper
5. Configure AS3 TS common log entities
6. Configure AS3 Juice Shop VS
7. Send TS Declaration to BIG-IP
8. Demo!
    1. Hit the server with load using locust
    2. Hit server with attacks using (?)
    3. Show Working web site
    4. Show Grafana dashboard
