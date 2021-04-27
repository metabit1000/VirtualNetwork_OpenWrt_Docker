# Scripts_TFG

Scripts used to create my virtual network with Docker and OpenWrt.

OpenWrt info: https://openwrt.org/about
Docker info: https://www.docker.com/

## Network topology

![alt text](https://github.com/metabit1000/Scripts_TFG/blob/master/images/EstructuraRed.png?raw=true)

## How execute the virtual network? (steps)

1. Firstly, it is mandatory to install Docker. The script config.sh has the commands to install it and the way to not use sudo when docker command is executed.
2. Create network bridges with createBridges.sh.
3. Execute the virtual network with networkCreation.sh. The first time takes at least 5-6 min (depends on your Internet connection) to download all the images from docker hub to your local repository.
4. Stop the containers and then the virtual network with stopContainers.sh.
5. If you open your browser and you use url: localhost:9000, you will see images and containers info (using a web interface instead of using docker commands).

When all the virtual network is running, it is time to do some testing on it. Black terminal (xterm) is pc.

**Important:**
If you want to access to each container individually, you have to execute the following command:
docker exec -it container_name type
Where type can be:
- /bin/ash --> All OpenWrt routers and droppyDMZ 
- /bin/bash --> Internet and pc

You can access to the router configuration via Luci, just using its url in your browser. (it can be accessible this way because of the bridge network gateway)
