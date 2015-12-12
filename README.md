# cd-poc
Continuous Deployment POC

## whatisdis

Will eventually contain a full example of continuous deployment to multiple Rancher-based environments.

## usage

### local testing

[rancher/rancher](https://github.com/rancher/rancher), forked with minor adjustments, has been git submoduled (`git submodule add git@github.com:smoll/rancher.git rancher-local-bootstrap`), so you can do

```
$ cd rancher-local-bootstrap
$ vagrant up
```

to bring up a Vagrant-based Rancher cluster locally to play around with locally.
