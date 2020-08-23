# docker-stack-wait-deploy
A script waiting for `docker stack deploy` command to complete.

## Why
Unfortunately, `docker stack deploy` [always run in detached mode](https://github.com/docker/cli/issues/373). 
It means it exits immediately and doesn't wait for services to actually update. 
This repo provides script that does the following:

* waits for all services in stack are updated (or errored)
* displays update progress per instance of each service
* returns exit code `0` in case of success and `1` in case of errors

## Usage
After calling `docker stack deploy $STACK_NAME` call the following:
```bash
docker run --rm vitalets/docker-stack-wait-deploy | bash /dev/stdin $STACK_NAME
```
Example output (interactively updated):
```
STATUS (nodejs_service): updating
ID                  NAME                   IMAGE                     NODE                DESIRED STATE       CURRENT STATE             ERROR               PORTS
h1isbgdgmwv1        nodejs_service.1       nodejs_service_prod:1.5   swarm-manager       Running             Preparing 2 seconds ago                       
8zu8v3waxyjx         \_ nodejs_service.1   nodejs_service_prod:1.4   swarm-manager       Running             Running 6 minutes ago                         
b45471xoq9d4        nodejs_service.2       nodejs_service_prod:1.4   swarm-manager       Running             Running 6 minutes ago                         
xyagddf48560        nodejs_service.3       nodejs_service_prod:1.5   swarm-manager       Running             Running 3 seconds ago                         
```

## Development
### Build image
```bash
docker build -t vitalets/docker-stack-wait-deploy .
```

### Publish image
```bash
docker push vitalets/docker-stack-wait-deploy
```

## Related projects
* [docker-stack-wait](https://github.com/sudo-bmitch/docker-stack-wait)
* [sure-deploy](https://github.com/issuu/sure-deploy)

