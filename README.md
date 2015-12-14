# cd-poc
Continuous Deployment POC

## whatisdis

Will eventually contain a full example of continuous deployment to multiple Rancher-based environments.

## Usage

### Locally

At any time, to suspend all VMs and free up memory do

```bash
vagrant halt
```

See playbooks and other Ansible-related files in [`provision`](./provision).

```bash
vagrant up
make docker
make server

# log into the UI, attempt to add a custom host, grab the extra long URL, e.g.
# http://192.168.50.101:8080/v1/scripts/68D59B73D0078EE13D1D:1450069200000:ZRBWdAu7IlVBSUlUtmpVvqnPtMo

make agent
```

to bring up a Vagrant-based Rancher cluster locally to play around with locally.

#### Quickstart

0. Connect to the stack via Rancher Compose CLI

    ```bash
    export RANCHER_URL=http://192.168.50.101:8080/
    export RANCHER_ACCESS_KEY=A9EC9CAD51B38A9504B5 # replace with real key, generated through the UI
    export RANCHER_SECRET_KEY=fzE3g4zJN2iKbhgajCKfEK1mD6kPb7qEHevJwSfd # replace this too

    cd compose
    rancher-compose -p myapp logs
    ```

0. Bring up all the services

    ```bash
    rancher-compose -p myapp up
    ```

#### Slow start

See [UI Steps](./UI-STEPS.md) for step-by-step instructions for how the Compose YMLs were generated.

### EC2

#### TODO:

* Create targets/flag for [HA Rancher Server](http://docs.rancher.com/rancher/installing-rancher/installing-server/multi-nodes/) EC2 bootstrap.

0. Create inventory file `ec2` that looks like

    ```
    [rancherserver]
    rancher-server ec2-54-204-214-172.compute-1.amazonaws.com

    [rancheragent]
    rancher-agent01 ec2-54-235-59-210.compute-1.amazonaws.com
    rancher-agent02 ec2-54-83-161-83.compute-1.amazonaws.com
    rancher-agent03 ec2-54-91-78-105.compute-1.amazonaws.com
    rancher-agent04 ec2-54-82-227-223.compute-1.amazonaws.com
    ```

0. Call the same `Makefile` targets as we would locally, except specify the inventory file we created as `hosts=<path_to_inventory_file>`

    ```bash
    make server hosts=ec2

    # log into the UI, attempt to add a custom host, grab the extra long URL

    make agent hosts=ec2
    ```

## Issues

* Affecting `make agent` idempotence: [Ansible docker module fails when re-pulling agent container](https://github.com/ansible/ansible-modules-core/issues/2257)
