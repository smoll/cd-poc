# cd-poc
Continuous Deployment POC

## whatisdis

Will eventually contain a full example of continuous deployment to multiple Rancher-based environments.

## Usage

### Locally

At any time, to suspend all VMs and free up memory do

```
$ vagrant halt
```

[rancher/rancher](https://github.com/rancher/rancher), forked with minor adjustments, has been git submoduled (`git submodule add git@github.com:smoll/rancher.git rancher-local-bootstrap`), so you can do

```
$ cd rancher-local-bootstrap
$ vagrant up
```

to bring up a Vagrant-based Rancher cluster locally to play around with locally.

#### Quickstart

0. Connect to the stack via Rancher Compose CLI

    ```
    export RANCHER_URL=http://172.19.8.100:8080/
    export RANCHER_ACCESS_KEY=A9EC9CAD51B38A9504B5 # replace with real key, generated through the UI
    export RANCHER_SECRET_KEY=fzE3g4zJN2iKbhgajCKfEK1mD6kPb7qEHevJwSfd # replace this too

    cd compose
    rancher-compose -p myapp logs
    ```

0. Bring up all the services

    ```
    rancher-compose -p myapp up
    ```

See [UI Steps](./UI-STEPS.md) for step-by-step instructions for how the Compose YMLs were generated.
