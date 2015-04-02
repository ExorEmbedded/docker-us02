FROM 32bit/ubuntu:14.04
MAINTAINER Exor info@exorint.it

# Use bash insted of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install required packages
RUN apt-get update && apt-get install -y git python diffstat texinfo gawk chrpath wget
RUN apt-get install -y build-essential sudo
RUN apt-get install -y x11vnc xvfb xinit

# Fake initscripts
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN dpkg-divert --local --rename --add /etc/init.d/systemd-logind
RUN ln -sf /bin/true /sbin/initctl
RUN ln -sf /bin/true /etc/init.d/systemd-logind
RUN apt-get install -y e17

# Clone repositories
RUN mkdir -p /home/user/git
WORKDIR /home/user/git
#RUN git clone -b exorint git://github.com/ExorEmbedded/yocto-poky.git
#RUN git clone -b exorint git://github.com/ExorEmbedded/yocto-meta-openembedded.git
#RUN git clone -b dora git://github.com/ExorEmbedded/meta-browser.git
#RUN git clone -b master git://github.com/ExorEmbedded/meta-exor-us02.git

# Install SDK
#RUN wget https://copy.com/AaxisLZ8tNeUhbLD?download=1 -O /opt/exor-alterakit-sdk.sh
#RUN chmod +x /opt/exor-alterakit-sdk.sh
#RUN /opt/exor-alterakit-sdk.sh
#RUN rm -f /opt/exor-alterakit-sdk.sh

# Install qtcreator
#RUN wget https://copy.com/LH2rFNOjRW4LCpdd?download=1 -O /opt/qt-creator-docker.tar.gz
#RUN tar xzf /opt/qt-creator-docker.tar.gz -C /opt qtcreator
#RUN ln -s /opt/qtcreator/bin/qtcreator /usr/bin/qtcreator
#RUN tar xzf /opt/qt-creator-docker.tar.gz -C /home/user .local .config
#RUN rm -f /opt/qt-creator-docker.tar.gz

# Init yocto environment and configure
#RUN source yocto-poky/oe-init-build-env ../build
#WORKDIR /home/user/build
#COPY ./bblayers.conf /home/user/build/conf/bblayers.conf
#COPY ./local.conf /home/user/build/conf/local.conf


# Bitbake wont run as root, create a new user
RUN useradd user && echo "user:password" | chpasswd && adduser user sudo
RUN chown -R user:user /home/user 
RUN chown -R root:root /usr/bin/sudo /var/lib/sudo /etc/sudoers* /usr/lib/sudo
RUN chmod 4755 /usr/bin/sudo /var/lib/sudo /etc/sudoers* /usr/lib/sudo

# Change user
USER user

# Strart VNC and openbox
RUN echo -e "x11vnc -forever -nopw -display :1 -rfbport 5555 & \n enlightenment_start \n" >> /home/user/.xinitrc
RUN mkdir /home/user/.vnc

# Export port 5555 to the host for VNC connection
EXPOSE 5555:5555

CMD bash -c 'export HOME=/home/user; /usr/bin/xinit -- /usr/bin/Xvfb :1 -screen 0 1280x768x16 &'; bash
