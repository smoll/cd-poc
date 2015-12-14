#### Slow start

After all 5 Vagrant hosts are up,

0. View the Rancher UI at [http://172.19.8.100:8080/](http://172.19.8.100:8080/) and do some one-time setup.
    * Go to Infrastructure > Hosts to ensure that `rancher-01` through `rancher-04` are all connected (this may take a minute).
    * Generate API key & secret pair for use by CI server. Click on the user icon in the top right > API & Keys > Add API Key > Name: `for CI` > _jot down the key & secret pair!_ > Save.
    * Other things to try (on AWS, not just Vagrant):
        * Rename "Default" env to e.g. "Staging", create another env called "Prod".
        * Configure access control via GitHub/LDAP auth by following the simple step-by-step directions.

0. Create a full stack
    * **Create `myapp` stack.**
        0. Applications > Stacks > Add Stack
        0. Name: `myapp`
    * **Create `redis` service definition.** (**NOTE:** on "actual Prod" we would use an ElastiCache instance defined as an `external_link`.)
        0. Add Service
        0. Name: `redis`
        0. Image: `redis`
        0. Scale: `1`
    * **Create `python-microservice` service definition.**
        0. Add Service
        0. Name: `python-microservice`
        0. Image: `smoll/python-microservice:latest`
        0. Scale: `2`
        0. Service Links (+)
            0. Destination Service: `redis`
            0. As Name: `redis`
    * **Create Load Balancer service definition.**
        0. Dropdown next to Add Service > Add Load Balancer
        0. Scale: `1`
        0. Name: `pymsLB`
        0. Add Port > Source Port: `80`
        0. Add Service, click "Show advanced routing options"
            0. Request Host: `pyms.mycompany.tld`
            0. Target Service: `python-microservice`

0. Save the generated `docker-compose.yml` and `rancher-compose.yml` (see the [`myapp`](../stacks/myapp) directory).

0. Press play to launch all services in the stack.
