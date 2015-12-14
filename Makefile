ANSIBLE_SSH_FLAGS := --private-key=~/.vagrant.d/insecure_private_key -u vagrant -i local_hosts --verbose
PLAYBOOK_PATH := provision

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""   1. make server       - run rancher server (then configure Auth)
	@echo ""   2. configure Auth then go to the add custom host page you will find the URL for your rancher Agents [http://rancherurl/static/infrastructure/hosts/add/custom]
	@echo ""   3. make agent       - run rancher agents you will be prompted for the above url (it will be cached locally, but due to gitignore it will be pretty hard for you to commit it)

deps:
	cd $(PLAYBOOK_PATH); ansible-galaxy install -r requirements.yml

server: docker haveged serverplay

docker:
	cd $(PLAYBOOK_PATH); ansible-playbook $(ANSIBLE_SSH_FLAGS) docker_platform.yml

haveged:
	cd $(PLAYBOOK_PATH); ansible-playbook $(ANSIBLE_SSH_FLAGS) haveged.yml

serverplay:
	cd $(PLAYBOOK_PATH); ansible-playbook $(ANSIBLE_SSH_FLAGS) rancher_server.yml

agent: url ip labels agentplay

url:
	@cd $(PLAYBOOK_PATH); while [ ! -f "./url" ]; do \
		read -r -p "Enter the url you wish to associate with this Rancher agent [url]: " url; echo "$$url">>url; cat url; \
	done ;

ip:
	@cd $(PLAYBOOK_PATH); while [ ! -f "./ip" ]; do \
		read -r -p "Enter the ip of the Rancher server you wish to associate with these Rancher agents this can be left blank [ip]: " ip; echo "$$ip">>ip; cat ip; \
	done ;

labels:
	@cd $(PLAYBOOK_PATH); while [ ! -f "./labels" ]; do \
		read -r -p "Enter the cattle host labels of the Rancher server you wish to associate with these Rancher agents this can be left blank [genus=rancher&phasse=test]: " labels; echo "$$labels">>labels; cat labels; \
	done ;

agentplay:
	cd $(PLAYBOOK_PATH); ansible-playbook $(ANSIBLE_SSH_FLAGS) rancher_agent.yml
