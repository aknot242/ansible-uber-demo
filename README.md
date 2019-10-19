# ansible-uber-demo
A comprehensive demonstration Ansible-based solution to quickly build and deploy an application in a public cloud using F5 and NGINX technology

## Featuring
- [F5 BIG-IP](https://www.f5.com/products/big-ip-services)
- [Grafana](https://grafana.com/)
- [Graphite](https://graphiteapp.org/)
- [StatsD](https://github.com/statsd/statsd)
- [ElasticSearch](https://www.elastic.co/products/elastic-stack)
- [Juice Shop app](https://hub.docker.com/r/bkimminich/juice-shop/)
- [OWASP Zed Attack Proxy (ZAP)](https://github.com/zaproxy/zaproxy)

## Dependencies
- [RedHat Ansible](https://www.ansible.com/) 2.8
- [Chef Inspec](https://www.inspec.io/) 4.7+

## Prerequisites
- This demo assumes an Ansible and [Docker](https://www.docker.com/) host running on [Ubuntu](https://ubuntu.com/) release 18.04 (Bionic)

```
docker run --rm -it willhallonline/ansible:2.8-ubuntu-18.04 /bin/sh
```

- The Ubuntu server must be able to connect to your specified BIG-IP. Run from within the container to validate configuration and connectivity.
```
inspec exec demo-setup --input bigip_host=[hostname of bigip] bigip_mgmt_port=[mgmt port of bigip]
```

- The BIG-IP must already be configured with a management address, and must already have an admin account password set. See [these instructions](https://support.f5.com/csp/article/K13121) for setting the admin password on BIG-IP.

- Both the BIG-IP and Ubuntu server require outbound conectivity to github.com and npmjs.com

## Usage
- ssh into your Ubuntu 18.04 docker container and execute the following:
    - `git clone https://github.com/aknot242/ansible-uber-demo.git`
    - `cd ansible-uber-demo`
    - `./install-ubuntu-dependencies.sh`. This will install the linux dependencies required to run Docker and Ansible.
    - `./deploy.sh`. This will run the Ansible playbook to configure everything.
    - If you would like to generate traffic to the Juice Shop site, use this example command from the Ubuntu server: `./run-load.sh example.com 10` . The first argument is the destination Virtual Server configured for Juice Shop. The second argument is the number of times the traffic generation script should run.
    - To attack the Juice Shop site scanning for security vulnerabilities, use this example command from the Ubuntu server: `./run-attack.sh <full URL of Juice Shop site>` .

## Attributions
- Thanks to [mrlesmithjr](https://github.com/mrlesmithjr) for his [Netplan Ansible Role](https://github.com/mrlesmithjr/ansible-netplan)

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
    2. Graphite & StatsD
    3. ElasticSearch
        1. API call to build the index
        2. API call to set the query size and fieldsize
        3. API call to set an indexable text field from ASM
5. Configure AS3 TS common log entities
6. Configure AS3 Juice Shop VS
7. Send TS Declaration to BIG-IP
8. Demo!
    1. Hit the server with load using locust
    2. Hit server with attacks using (?)
    3. Show Working web site
    4. Show Grafana dashboard
