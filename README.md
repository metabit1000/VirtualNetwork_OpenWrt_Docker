# Creation of a Virtual Network using OpenWrt and Docker

Repository for bash scripts used in my final degree project of Bachelor's degree in Informatics Engineering (UPC). 

The project consists of a consistent case study about virtualization of routers to have Internet access redundancy. The objective has been to install a computer network with different virtual routers running in Docker containers that implement this redundancy, in addition to the experimental study of their behavior. As a virtual router, the Linux-based distribution OpenWrt has been used, which implements a router designed for embedded systems. For the redundancy of routers, a  research has been done first to decide the best option within the possibilities offered by OpenWrt; mwan3 or keepalived. And finally, a network monitoring system (Nagios) has been installed to detect the failover of the main route and also to check the status of the virtual routers on the network.

Links to the technologies used: 
- OpenWrt info: https://openwrt.org/about
- Docker info: https://www.docker.com/
- Nagios info: https://www.nagios.org/

Links to the redundancy packets (OpenWrt):
- mwan3: https://openwrt.org/docs/guide-user/network/wan/multiwan/mwan3
- keepalived: https://openwrt.org/docs/guide-user/network/high-availability

## Network topology

![alt text](https://github.com/metabit1000/Scripts_TFG/blob/master/images/EstructuraRed.png?raw=true)

## How execute the virtual network? (steps)

1. Firstly, it is mandatory to install Docker. The script docker_config.sh has the commands to install it and the way to not use sudo when docker command is executed.
2. Create network bridges with createBridges.sh. (mandatory)
3. Execute the virtual network with networkCreation.sh or vrrpNetworkCreation.sh. NetworkCreation executes the virtual network using mwan3 and vrrpNetworkCreation.sh using keedpalived. The first time takes at least 5-6 min (depends on your Internet connection) to download all the images from docker hub to your local repository.
4. If you open your browser and you use url: localhost:9000, you will see images and containers info (using a web interface instead of using docker commands).
5. When you finish testing, stop the containers and then the virtual network with stopContainers.sh.

When all the virtual network is running, it is time to do some testing on it. Black terminal (xterm) is pc.

**Important:**
If you want to access to each container individually, you have to execute the following command: 


``
docker exec -it container_name type
``

Where type can be:
- /bin/ash --> All OpenWrt routers and droppyDMZ.
- /bin/bash --> Internet, pc and nagios.

You can access to the router configuration via Luci, just using its url in your browser. And using ssh -p 22 root@router_ip. (it can be accessible this way because of each bridge network gateway)

## Scripts and its use in the project

- configDefaultRoute.sh: Code executed in pc, file server and nagios to configure the correct default route.
- createBridges.sh: Code that creates the docker network bridges to provide connectivity between the different containers (see network structure to understand better)
- docker_config.sh: It has the commands to install Docker and the way to not use sudo when docker command is executed.
- failover.sh: One of the alternatives to have Internet access redundancy. Own code. 
- networkCreation.sh: Code that creates all the virtual network.
- redundancyTest.sh: Code used to prove that the redundancy is working depending on the choosen redundancy option (mwan3, own code, vrrp)
- removeBridges.sh: Useful code if you want to remove the docker network bridges of your computer.
- stopContainers.sh: Code to stop the virtual network. 

In check_nagios folder, you can find the the nagios plugins and the scripts executed in MW router.

## Demo

![alt text](https://github.com/metabit1000/Scripts_TFG/blob/master/videos/demo.gif)

Feel free to use it for own interests and improve it!
