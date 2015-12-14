ansible_ssh_flags = --private-key=~/.vagrant.d/insecure_private_key -u vagrant -i $(hosts) --verbose
playbooks_path = provision
hosts := vagrant_hosts

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""   1. make server       - run rancher server (then configure Auth)
	@echo ""   2. configure Auth then go to the add custom host page you will find the URL for your rancher Agents [http://rancherurl/static/infrastructure/hosts/add/custom]
	@echo ""   3. make agent       - run rancher agents you will be prompted for the above url (it will be cached locally, but due to gitignore it will be pretty hard for you to commit it)

deps:
	cd $(playbooks_path); ansible-galaxy install -r requirements.yml

server: haveged serverplay

# Install Docker platform on all hosts in inventory file
docker:
	cd $(playbooks_path); ansible-playbook $(ansible_ssh_flags) docker_platform.yml

haveged:
	cd $(playbooks_path); ansible-playbook $(ansible_ssh_flags) haveged.yml

serverplay:
	cd $(playbooks_path); ansible-playbook $(ansible_ssh_flags) rancher_server.yml

agent: url ip labels agentplay

url:
	@cd $(playbooks_path); while [ ! -f "./url" ]; do \
		read -r -p "Enter the url you wish to associate with this Rancher agent [url]: " url; echo "$$url">>url; cat url; \
	done ;

ip:
	@cd $(playbooks_path); while [ ! -f "./ip" ]; do \
		read -r -p "Enter the ip of the Rancher server you wish to associate with these Rancher agents this can be left blank [ip]: " ip; echo "$$ip">>ip; cat ip; \
	done ;

labels:
	@cd $(playbooks_path); while [ ! -f "./labels" ]; do \
		read -r -p "Enter the cattle host labels of the Rancher server you wish to associate with these Rancher agents this can be left blank [genus=rancher&phasse=test]: " labels; echo "$$labels">>labels; cat labels; \
	done ;

agentplay:
	cd $(playbooks_path); ansible-playbook $(ansible_ssh_flags) rancher_agent.yml
