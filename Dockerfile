FROM 32bit/ubuntu:14.04
MAINTAINER Exor info@exorint.it

# Use bash insted of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install required packages
RUN apt-get update && apt-get install -y git python diffstat texinfo gawk chrpath wget nano
RUN apt-get install -y build-essential sudo
RUN apt-get install -y x11vnc xvfb xinit

# Fake initscripts
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN dpkg-divert --local --rename --add /etc/init.d/systemd-logind
RUN ln -sf /bin/true /sbin/initctl
RUN ln -sf /bin/true /etc/init.d/systemd-logind
RUN apt-get install -y e17

# Setup avahi to autoconnect to device
RUN apt-get install -y avahi-daemon avahi-utils
EXPOSE 5353/udp
RUN mkdir -p /var/run/dbus

# to use avahi in with --net host we need to rebuild pam with disable-audit to due a kernel bug solved in kernels > 3.15
#Setup build environment for libpam
RUN cat /etc/apt/sources.list | sed  s/deb/deb-src/ >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y build-dep pam
#Rebuild and istall libpam with --disable-audit option
RUN export CONFIGURE_OPTS=--disable-audit && cd /root && apt-get -b source pam && dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb


# Bitbake wont run as root, create a new user
RUN useradd -m -d /home/user -s /bin/bash user && echo "user:password" | chpasswd && adduser user sudo
RUN chown -R user:user /home/user 

# Change user
USER user
ENV HOME /home/user

# Clone repositories
RUN mkdir ~/git
WORKDIR /home/user/git
RUN git clone -b exorint git://github.com/ExorEmbedded/yocto-poky.git
RUN git clone -b exorint git://github.com/ExorEmbedded/yocto-meta-openembedded.git
RUN git clone -b dora git://github.com/ExorEmbedded/meta-browser.git
RUN git clone -b master git://github.com/ExorEmbedded/meta-exor-us02.git

# Install SDK
#RUN wget https://copy.com/AaxisLZ8tNeUhbLD?download=1 -O ~/exor-alterakit-sdk.sh
#RUN chmod +x ~/exor-alterakit-sdk.sh
#RUN ~/exor-alterakit-sdk.sh
#RUN rm -f ~/exor-alterakit-sdk.sh

# Install qtcreator
#RUN wget https://copy.com/LH2rFNOjRW4LCpdd?download=1 -O ~/qt-creator-docker.tar.gz
#RUN tar xzf ~/qt-creator-docker.tar.gz -C ~ qtcreator
#RUN ln -s ~/qtcreator/bin/qtcreator /usr/bin/qtcreator
#RUN tar xzf ~/qt-creator-docker.tar.gz -C ~ .local .config
#RUN rm -f ~/qt-creator-docker.tar.gz

# Init yocto environment and configure
#RUN source yocto-poky/oe-init-build-env ../build
#WORKDIR ~/build
#COPY ./bblayers.conf ~/build/conf/bblayers.conf
#COPY ./local.conf ~/build/conf/local.conf

# Start VNC and desktop
RUN echo -e "x11vnc -forever -nopw -display :9 -rfbport 5555 & \n enlightenment_start \n" >> ~/.xinitrc
RUN mkdir ~/.vnc

# Export port 5555 to the host for VNC connection
EXPOSE 5555:5555

USER root

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/user
CMD bash -c '  dbus-daemon --system; avahi-daemon --no-drop-root -D; su user -c "/usr/bin/xinit -- /usr/bin/Xvfb :9 -screen 0 1280x768x16  & "'; su user 
