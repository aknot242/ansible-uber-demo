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
- F5 BIG-IP 14.1.0.3-0.0.6 (or greater) with LTM and ASM modules licensed
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
    - If you would like to generate traffic to the Juice Shop site, use this example command from the Ubuntu server: `./run-load.sh http://10.1.10.20 10` . The first argument is the destination Virtual Server configured for Juice Shop. The second argument is the number of times the traffic generation script should run.
    - To attack the Juice Shop site scanning for security vulnerabilities, use this example command from the Ubuntu server: `./run-attack.sh http://10.1.10.20` .

## Pinning to specific BIG-IP Package Versions
The F5 Automation Toolchain packages used in this project are [Application Services 3](https://github.com/F5Networks/f5-appsvcs-extension), [Declarative Onboarding](https://github.com/F5Networks/f5-declarative-onboarding) and [Telemetry Streaming](https://github.com/F5Networks/f5-telemetry-streaming). The default variables in the Ansible Playbook are configured to use specific tagged releases for each of these packages. The default values can be seen [here](ansible/roles/big-ip/defaults/main.yml). You can also specify that you would like Ansible to fetch the latest release, no matter the tag using the `<package name>_use_latest` variables per package.

## Attributions
- Thanks to [mrlesmithjr](https://github.com/mrlesmithjr) for his [Netplan Ansible Role](https://github.com/mrlesmithjr/ansible-netplan)

## Playbook Flow
The following is a high-level flow of the steps taken when preparing for and executing this playbook. (* denotes steps that are not currently implemented for you):

1. Git pull Ansible workbooks *
2. Build Ubuntu host *
3. Install Ubuntu dependencies
4. Build BIG-IPs
    1. Install Declarative Onboarding (DO)
    2. Install Application Services 3 (AS3)
    3. Install Telemetry Streaming (TS)
5. Build containers
    1. Grafana
        1. API call to install GeoLocation map plugin
        2. API call to add datasources
        3. API call to import JSON dashboard
    2. Graphite & StatsD
    3. ElasticSearch
        1. API call to build the index
        2. API call to set the query size and fieldsize
        3. API call to set field settings
6. Configure AS3 TS common log entities
7. Configure AS3 Juice Shop VS
8. Send TS Declaration to BIG-IP
9. Demo!
    1. Send automated requests to Juice Shop application
    2. Execute OWASP ZAP to discover and exploit vulnerabilities in Juice Shop application
    3. Show working Juice Shop web site
    4. Show Grafana dashboard

## Demo Flow
The following are the actual steps needed to execute the demo:

1. Boot up images
2. Ssh into BIG-IP and run the following
    1. `tmsh`
    2. `modify auth user admin prompt-for-password`
    3. `save sys config`
    4. `quit`
3. Ssh into Ubuntu server and run the following
    1. `git clone https://github.com/aknot242/ansible-uber-demo.git`
    2. `cd ansible-uber-demo`
    3. Set password in host vars file: `nano ansible/host_vars/10.1.1.4.yml` 
    4. Run `./install-ubuntu-dependencies.sh`
    5. Run `./deploy.sh`
    6. Run `load script ./run-load.sh http://10.1.10.20 10`
    7. Run `attack script  ./run-attack.sh http://10.1.10.20`