Exor Altera Starter KIT development image
=========================================

This repo provides the Dockerfile to build Exor Altera Starter KIT development image.

This image is preconfigured to cross compile, deploy and debug the BSP, kernel and applications of Exor Altera Starter KIT.

Build:
-----

```
   docker build -t exorembedded/docker-us02-32bit .
```


First time run
---------------

```
   docker run --name us02 --net host -v /local/folder:/home/user/share -ti exorembedded/docker-us02-32bit
```

Option `--name us02` allows to easily control the container by name using the command line docker utility.

Option `--net host` will bridge all network connections of the hosting machine. So it is possible to use avahi do resolve the target machine hostname (exoralterakit.local).

Option `-v /local/folder:/home/user/share` binds the host folder `/local/folder` to the container folder `/home/user/share`.



Tipical usage
-----------

```
   docker start -ai us02
```

```
   Ctrl+D
```

or

```
   docker stop us02
```
   
to exit session.


UI available via VNC (port 5555) while the console is running. 

Tips:
-----

`docker ps -a` shows current available containers

`docker rm <container_name>` removes specified container



    