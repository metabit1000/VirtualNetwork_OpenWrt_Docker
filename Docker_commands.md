# Docker

https://luisiblogdeinformatica.com/docker-cheatsheet-comandos-mas-usados/

*Online hub for public docker images*
https://hub.docker.com/_/busybox

## Commands

##Otros

iptables -t nat -L
scp root@10.0.2.1:.droppy/files/file1.txt file1.txt

### Useful for my project

```
docker exec -it router1 /bin/ash  (create a terminal in the openwrtimage)
```
```
docker cp foo.txt mycontainer:/foo.txt  (cp file from host to container)
```

### More docker commands

##### Pull an image from docker docker Hub** (to our local repository)

```
docker pull [image]:[tag]
```

##### Push an image to docker docker Hub repository** (from our local repository)

```
docker push [image]:[tag]

-->docker.io/[accountName]/[containerName]
```

##### Remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes.

```
docker system prune -a
```

##### List downloaded images:

```
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
busybox             latest              83aa35aa1c79        4 weeks ago         1.22MB
```
##### Delete an Image:

```
docker rmi [image_id]
# remove all the container that use that image before
```
##### List all containers (running and stopped)

```
docker ps -a
```
##### Run the image (and print a message)

```
docker run busybox echo "hello world"
docker restart
```
##### Run the image for interactive process (shell)

```
docker run -i -t busybox
docker run -it busybox
docker run -dit busybox (d --> executed in the background)
```
##### Run the image in detached mode for 10sec

```
docker run --name hello_world -d busybox sleep 10
## it prints the container_id
```
##### Inspect a running container
*Image sha, path log,  IPAddress, MacAddress*

```
docker inspect [container_id]
```
##### Run image and remove the container (when it finishes)

```
docker run --rm -d busybox sleep 1
```
##### Port Mapping
*-p host_port:container_port*

```
docker run -it -p 8888:8080 tomcat
```

##### Run an image and put a file inside
*-v host_route(where the file is):container_route(where i want to put the file)*

```
docker run -it -p 8888:8080 -v "$PWD/web":"/usr/prueba" tomcat
```

##### Show container logs:

```
docker logs [container_id]
```
##### Stop a running container (useful when in detached mode):

```
docker stop [container_id]
```
##### Remove a stopped container from the list: 

```
docker rm [container_id]
```
##### Build docker image:

```
docker build -t [docker_hub_user]/[imagename] .
# it creates an unofficial image
# the command build looks for the Dockerfile file in the current path
# the Dockerfile is passed as a context
# the intermediates container, on which every single RUN command is executed, is removed
```
##### Commit changes in an image:

```
docker commit [container_id] [repository_name:tag] (local repository)
## es:
docker commit -m "personal test image" 77de3aff9d25 gdigialluca/debian:1.00
```
##### Execute a command on a running container (allows to enter the container console)

```
docker exec -it [container_id] bash
```
+ To exit: exit/Control+C

##### Docker volume
It is the simple and predefined way to store all the files (with a few exceptions) of a container, it will use the space of our PC
and in “/var/lib/docker/volumes” it will create a folder for each container.

```
docker volume ls
docker volume rm [name]
docker volume create [name]
```

##### Docker stats

```
docker stats
```

##### Docker network

```
docker network ls
docker network create --subnet [ip] --gateway [ip] --ip-range [ip-range] [networkName]
docker network inspect [networkName]
docker network rm [networkName]
docker network connect [networkName] [container-id] 
```

##### List images of my local repository

```
docker image ls
```



## Docker compose

> see docker-compose.yaml

```
docker-compose up -d
```
##### Check containers status included in docker-compose

```
docker-compose ps
```
##### Logs from more run container

```
# from all runned container
docker-compose logs -f

# from a specic container
docker-compose logs dockerapp
```
##### Stop containers included in docker-compose

```bash
docker-compose stop
```
##### Remove containers included in docker-compose

```bash
docker-compose rm
```
##### Rebuild all the images specified in docker-compose

```shell
docker-compose build
```

## Link containers

the destination connected to our container will be Redis

Python client for redis:
https://pypi.org/project/redis/

> See the attached project (Dockerfile, pyhton and html template) in a zip
> dockerapp_v0.3.zip

##### Run redis docker image:

*--name redis* to define the container image

```
docker run -d --name redis redis:3.2.0
```

##### In Pythton use the reference redis (as an address)

```
cache = redis.Redis(host='redis', port=6379, db=0)
```

##### build the image and run the container

```
docker run -d -p 5000:5000 --link redis dockerapp:v0.3
```

> With this command in the /etc/host of dockerapp container docker adds a link to the redis container using its ip (check it using 'docker inspect')



## First web app dockerized:

*it use [Flask](https://flask.palletsprojects.com/en/1.1.x/)*

```
git clone https://github.com/jleetutorial/dockerapp.git
```

\#*move to dockerapp folder*

```
docker build -t dockerapp:v0.1 .
docker images
docker run -d -p 5000:5000 72251c42b3c3
```

-> open localhost:5000 from a browser

## Push image on docker hub
1- first retag the image with the correct name

```
docker tag [image_id] [docker_hub_id]/[repository_name]:[tag|version]
docker tag 488cff164007 gdigialluca/debian:1.02
```
*note: if tag is not specified, docker will use latest. latest not updated automatically uploading next tagged version: so **avoid using latest tag.** *

2- Login to docker hub repo and push

```
docker login --username=gdigialluca
docker push gdigialluca/debian:1.02
```
*note: it might take a while for the docker image to appear in Dockerhub*

## Image's layer

```
docker history [image_name]
docker history [busybox]
```
Only the last layer is writeble, all the others are readable only

- All changes made into the running container will be written into the writable layer
- When the container is deleted, the writable layer is also deleted, but the underlying image remains unchanged
- multiple containers can share access to the same underlying image

## Dockerfile 

[Commands documentation](https://docs.docker.com/engine/reference/builder/)

#### Dockerfile example 

file named Dockerfile without extension:

```
FROM debian:jessie
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y vim
```
#### Best practice and commands

1- Each RUN instruction will create a new image layer. For this reason it's recommended to chain the RUN instructions in the Dockerfile to reduce the number of images layer it creates.

```
FROM debian:jessie
RUN apt-get update && RUN apt-get install -y \
git \
vim
```

2- Sort Multi-line Arguments alphanumerically 
(to avoid duplication of packages and make the list much easier to update)

```
FROM debian:jessie
RUN apt-get update && RUN apt-get install -y \
git \
python \
vim
```

3- CMD instruction
specifies what command you want to run when the container strats up
*if not specified, docker will use the default command defined in the base image (bash for linux)*

```
FROM debian:jessie
RUN apt-get update && RUN apt-get install -y \
git \
python \
vim

CMD ["echo", "hello world"]
```

4- Docker Cache
for each command docker creates a layer, but if doesn't change it'll be reused
in the log of previous Docker file: * ---> Using cache*
disable caching:

```
docker build -t [repository/image:tag] . --no-cache=true
```

5- COPY files or directory
copy file or directories from build context and adds them to the file system of the container
*abc.txt in the same folder of Dockerfile*

 ```
FROM debian:jessie
RUN apt-get update && RUN apt-get install -y \
git \
vim

COPY abc.txt /src/abc.txt
 ```

6- ADD command
copy file or download a file from internet and copy to the container. the ADD command also has the ability to automatically unpack compressed file. For transparency use copy unles ADD is absolutely needed

```
ADD [--chown=<user>:<group>] <src>... <dest>
ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
```

### .dockerignore

#### What is?

Before the docker CLI sends the context to the docker daemon, it looks for a file named `.dockerignore` in the root directory of the context. If this file exists, the CLI modifies the context to exclude files and directories that match patterns in it. This helps to avoid unnecessarily sending large or sensitive files and directories to the daemon and potentially adding them to images using `ADD` or `COPY`. Full documentation [here](https://docs.docker.com/engine/reference/builder/#dockerignore-file).

#### Different .dockerignore for different dockerfile

Docker 19.03 shipped a solution for this.

The Docker client tries to load `<dockerfile-name>.dockerignore` first and then falls back to `.dockerignore` if it can't be found. So `docker build -f Dockerfile.foo .` first tries to load `Dockerfile.foo.dockerignore`.

Setting the `DOCKER_BUILDKIT=1` environment variable is currently required to use this feature. This flag can be used with `docker compose` since [1.25.0-rc3](https://github.com/docker/compose/pull/6865#issuecomment-546929648) by [also specifying `COMPOSE_DOCKER_CLI_BUILD=1`](https://github.com/docker/compose/pull/6865).

```shell
export DOCKER_BUILDKIT=1
```

Source [here](https://stackoverflow.com/questions/40904409/how-to-specify-different-dockerignore-files-for-different-builds-in-the-same-pr?newreg=70b34d7797ab4448834038e671898f7a).

> 1. Note the custom `dockerignore` should be in the same directory as the `Dockerfile` and not in root context directory like the original `.dockerignore`
> 2. If the Dockerfile is in a subdirectory of the context, the contained paths are relative to the location of the context

## Definitions

### Images:

- Images are read only templates used to create containers
- Images are created with the Docker build command, either by us or by other docker user
- Images are composed of layers of other images
- Image are stored in a docker registry

### Containers:

- If an Image is a class, then a container is an instance of a class - a runtime object
- Containers are lightweight and portable encapsulations of an environment in wich to run applications
- Containers are created from images. Inside a container, it has all the binaries and dependencies needed to run the application

### Registries and Repositories

- A registry is where we store our images
- You can host your own registry, or you can use Docker's public registry which is called DockerHub
- Inside a registry, images are stored in repositories
- Docker repository is a collection of different docker images with the same name, that have different tags, each tag usually represents a different version of the image



## Logs updating Pyhton

```
brew install python

..........
==> python
Python has been installed as
  /usr/local/bin/python3

Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
`python3`, `python3-config`, `pip3` etc., respectively, have been installed into
  /usr/local/opt/python/libexec/bin

You can install Python packages with
  pip3 install <package>
They will install into the site-package directory
  /usr/local/lib/python3.7/site-packages

See: https://docs.brew.sh/Homebrew-and-Python
```
Update pip and install redis
*--user used due to permission errors*

```
pip3 install --user --upgrade pip
pip3 install --user redis 
```

where is docker-compose and add to terminal Path

```bash
gdg@mbp-di-giovanni ~ % which docker-compose
/usr/local/bin/docker-compose
```

