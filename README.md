Exor Starter KIT development image
=========================================

This repo provides the Dockerfile to build Exor Starter KIT development image.

This image is preconfigured to cross compile, deploy and debug the BSP, kernel and applications of Exor Altera Starter KIT.

Build
-----

```
   docker build -t exorembedded/docker-us02-32bit .
```


First time run
---------------

```
   docker run --name exor --net host -v /local/folder:/home/user/share -ti exorembedded/docker-us02-32bit
```

Option `--name exor` allows to easily control the container by name using the command line docker utility.

Option `--net host` bridges all network interfaces of hosting machine. So it is possible to use avahi to resolve the starter kit hostname (exoralterakit.local).

Option `-v /local/folder:/home/user/share` binds the host folder `/local/folder` to the container folder `/home/user/share`.



Tipical usage
-----------

```
   docker start -ai exor
```

```
   Ctrl+D
```

or

```
   docker stop exor
```
   
to exit session.


UI available via VNC (port 5555) while the console is running. 

Tips
-----

`docker ps -a` shows current available containers

`docker rm <container_name>` removes specified container



    
