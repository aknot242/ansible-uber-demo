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
- This demo assumes an environment build using http://github.com/mjmenger/terraform-aws-bigip-setup. Connect to the jumphost using the information and credentials provided by the environment build.

- The jumphost must be able to connect to your specified BIG-IP. Run the following from within the jumphost to validate configuration and connectivity.
```
inspec exec demo-setup --input bigip_host=[hostname of bigip] bigip_mgmt_port=[mgmt port of bigip]
```

- Both the BIG-IP and Ubuntu server require outbound conectivity to github.com and npmjs.com

## Usage
- before connecting to your jumphost, place the private key on the jumphost with the following command
```bash
scp -i <path to privatekeyfile> ubuntu@<ubuntuserver>:~/privatekeyfile
```

- ssh into your jumphost with the following command
```bash
ssh -i <path to privatekeyfile> ubuntu@<ubuntuserver>
```

- prepare the jumphost to run the ansible playbook with the follow commands
```bash
git clone https://github.com/mjmenger/ansible-uber-demo.git 
cp ~/inventory.yml ~/ansible-uber-demo/ansible/inventory.yml
cd ansible-uber-demo
./install-ubuntu-dependencies.sh # This will install the linux dependencies required to run Docker and Ansible.
```
- run the ansible playboook with the following command
``` bash
./deploy.sh
```

- If you would like to generate traffic to the Juice Shop site, use following command from the jumphost. The first argument is the destination Virtual Server configured for Juice Shop. The second argument is the number of times the traffic generation script should run.
 ```bash
 ./run-load.sh http://10.1.10.20 10
 ```
 - To attack the Juice Shop site scanning for security vulnerabilities, use this example command from the jumphost. The first argument is the destination Virtual Server configured for Juice Shop. 
 ```bash
 ./run-attack.sh http://10.1.10.20
```
## Pinning to specific BIG-IP Package Versions
The F5 Automation Toolchain packages used in this project are [Application Services 3](https://github.com/F5Networks/f5-appsvcs-extension), [Declarative Onboarding](https://github.com/F5Networks/f5-declarative-onboarding) and [Telemetry Streaming](https://github.com/F5Networks/f5-telemetry-streaming). The default variables in the Ansible Playbook are configured to use specific tagged releases for each of these packages. The default values can be seen [here](ansible/roles/big-ip/defaults/main.yml). You can also specify that you would like Ansible to fetch the latest release, no matter the tag using the `<package name>_use_latest` variables per package.


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
    6. Run load script: `./run-load.sh http://10.1.10.20 10`
    7. Run attack script: `./run-attack.sh http://10.1.10.20`

## Variable Reference
Variables can be overridden in a number of locations in the playbooks. Primarily, the variables are set in the [inventory.yml](ansible/inventory.yml) file. To learn about variable precendence in Ansible, see the [user guide](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable).

### Common variables (applied to all hosts in inventory)
| Variable Name | Description | Required |
|---------------------|---|:-:|
| ansible_connection  | Connection type used when connecting to the Ubuntu host. |*|
| ansible_user        | User name with which to login to the Ubuntu server via ssh. |*|
| ansible_become      | determines if privilege escalation is used while issuing Ansible tasks on the Ubuntu server. |*|
| app_server_address  | The address that is assigned to the Juice Shop and Grafana Virtual Server pool members. <br /> If the add_ubuntu_interface variable is set to true, this address will also be assigned to the eth1 interface<br /> of the Ubuntu server. |*|


### ***Server*** host variables
| Variable Name            | Description | Required |
|--------------------------|---|:-:|
| ansible_connection       | Instructs ansible to suppress the use of ssh when <br />connecting to this host. More info [here](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html). |*|
| app_server_gateway       | The gateway address to be used when creating the additional <br />interface on the Ubuntu server. ||
| add_ubuntu_interface     | Boolean to add an optional network interface (eth1) to the Ubuntu server using the NetPlan role. ||


### ***BIG-IP*** host variables
| Variable Name            | Description | Required |
|--------------------------|---|:-:|
| bigip_provider           | BIG-IP management connection information. <br />Documented [here](https://docs.ansible.com/ansible/latest/modules/bigip_appsvcs_extension_module.html#bigip-appsvcs-extension-module).|*|
| bigip_validate_certs     | Determines whether or not a TLS certificate is validated <br />when connecting to the BIG-IP's management API for the scope of the Ansible plays. |*|
| bigip_domain             | Used when building the FQDN portion of the BIG-IP host <br />name as well as the DNS search suffix. |*|
| bigip_hostname           | Fully qualified host name of the BIG-IP. |*|
| bigip_ntp_server         | A comma-separated double-quoted list of NTP servers that the BIG-IP should use. |*|
| bigip_ntp_timezone       | The name of the NTP timezone. See the ***TZ database name*** <br /> column on [this page](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for examples. |*|
| bigip_dns_server         | A quoted IP address of your DNS server. |*|
| bigip_dns_search         | The DNS search domain. |*|
| bigip_external_self_ip   | The BIG-IPs self-ip address on the external interface. |*|
| bigip_internal_self_ip   | The BIG-IPs self-ip address on the internal interface. |*|
| juiceshop_virtual_address| The IP address of the Juice Shop Virtual Server that will be created. |*|
| grafana_virtual_address  | The IP address of the Grafana Virtual Server that will be created. |*|
| log_pool                 | The IP address of the Virtual Server and looging pool that the LTM Request Policy and ASM Logs will target.<br /> Recommended to use an IP address on the Internal network, as it is not needed to be accessed publically. |*|
| bigip_license            | The license key for the BIG-IP. If not specified, the BIG-IP will not be licensed when the playbook runs. ||


## Attributions
- Thanks to [mrlesmithjr](https://github.com/mrlesmithjr) for his [Netplan Ansible Role](https://github.com/mrlesmithjr/ansible-netplan)
