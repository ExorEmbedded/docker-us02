FROM ubuntu:14.04
MAINTAINER Exor info@exorint.it

# Use bash insted of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install required packages
RUN apt-get update && apt-get install -y git python diffstat texinfo gawk chrpath wget
RUN apt-get install -y build-essential x11vnc xvfb openbox xinit sudo

# Clone repositories
RUN mkdir -p /home/user/git
WORKDIR /home/user/git
RUN git clone -b exorint git://github.com/ExorEmbedded/yocto-poky.git
RUN git clone -b exorint git://github.com/ExorEmbedded/yocto-meta-openembedded.git
RUN git clone -b dora git://github.com/ExorEmbedded/meta-browser.git
RUN git clone -b master git://github.com/ExorEmbedded/meta-exor-us02.git

# Install SDK
RUN wget https://copy.com/AaxisLZ8tNeUhbLD?download=1 -O /opt/exor-alterakit-sdk.sh
RUN chmod +x /opt/exor-alterakit-sdk.sh
RUN /opt/exor-alterakit-sdk.sh
RUN rm -f /opt/exor-alterakit-sdk.sh

# Install qtcreator
RUN wget https://copy.com/LH2rFNOjRW4LCpdd?download=1 -O /opt/qt-creator-docker.tar.gz
RUN tar xzf /opt/qt-creator-docker.tar.gz -C /opt qtcreator
RUN ln -s /opt/qtcreator/bin/qtcreator /usr/bin/qtcreator
RUN tar xzf /opt/qt-creator-docker.tar.gz -C /home/user .local .config
RUN rm -f /opt/qt-creator-docker.tar.gz

# Init yocto environment and configure
RUN source yocto-poky/oe-init-build-env ../build
WORKDIR /home/user/build
COPY ./bblayers.conf /home/user/build/conf/bblayers.conf
COPY ./local.conf /home/user/build/conf/local.conf

# Strart VNC and openbox
RUN echo -e "x11vnc -forever -nopw -display :1 -rfbport 5555 & \n \
        /usr/bin/openbox-session " >> /etc/startup
RUN chmod +x /etc/startup
RUN mkdir /home/user/.vnc
RUN echo -e "exec &> /dev/null \n \
	xinit /etc/startup -- /usr/bin/Xvfb :1 -screen 0 800x600x16 &" > /xinit
RUN chmod +x /xinit

# Export port 5555 to the host for VNC connection
#EXPOSE 5555:5555

# Bitbake wont run as root, create a new user
RUN useradd user && echo "user:password" | chpasswd && adduser user sudo
RUN chown -R user:user /home/user 
RUN chown -R root:root /usr/bin/sudo /var/lib/sudo /etc/sudoers* /usr/lib/sudo
RUN chmod 4755 /usr/bin/sudo /var/lib/sudo /etc/sudoers* /usr/lib/sudo

# Change user
USER user

CMD bash -C '/xinit';'bash'
