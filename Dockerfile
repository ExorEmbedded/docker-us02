FROM ubuntu:14.04
MAINTAINER Exor info@exorint.it
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install -y git python diffstat texinfo gawk chrpath wget
RUN apt-get install -y build-essential x11vnc xvfb openbox xinit
RUN useradd user
RUN mkdir -p /home/user/git
WORKDIR /home/user/git
RUN git clone -b exorint git://github.com/ExorEmbedded/yocto-poky.git
RUN git clone -b exorint git://github.com/ExorEmbedded/yocto-meta-openembedded.git
#RUN git clone -b exorint git://github.com/ExorEmbedded
COPY ./exor-alterakit-sdk.sh /etc/exor-alterakit-sdk.sh
RUN /etc/exor-alterakit-sdk.sh
RUN wget -P /etc http://download.qt.io/official_releases/qtcreator/3.3/3.3.2/qt-creator-opensource-linux-x86-3.3.2.run
RUN chmod +x /etc/qt-creator-opensource-linux-x86-3.3.2.run && /etc/qt-creator-opensource-linux-x86-3.3.2.run

RUN apt-get install nano

RUN source yocto-poky/oe-init-build-env ../build
WORKDIR /home/user/build
COPY ./bblayers.conf /home/user/build/conf/bblayers.conf
COPY ./local.conf /home/user/build/conf/local.conf
COPY ./meta-exor-us02 /home/user/git
RUN chown -R user:user /home/user
RUN echo -e "exec &> /dev/null \n \
	x11vnc -forever -display :1 -rfbport 2235 & \n \
	/usr/bin/openbox-session " >> /etc/startup
RUN chmod +x /etc/startup
RUN mkdir /home/user/.vnc
RUN echo "xinit /etc/startup -- /usr/bin/Xvfb :1 -screen 0 800x600x16 &" > /xinit
EXPOSE 2235
USER user
CMD bash -C '/xinit';'bash'

