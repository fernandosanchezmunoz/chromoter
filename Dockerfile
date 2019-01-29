FROM debian:stretch-slim
MAINTAINER Fernando Sanchez <fernandosanchezmunoz@gmail.com>

#security: ensure firewall permits outbound UDP traffic, permits inbound UDP responses, 
#and allows traffic on TCP ports 443 (HTTPS) and 5222 (XMPP)

ENV DEBIAN_FRONTEND noninteractive

#name for this instance, passed as a parameter or default
ARG NAME="chromoter"
ENV NAME=$NAME

#this image needs the Chrome remote desktop "code=4/xxxxxxxxxxxxxxxxxxxxxxxx"
#as an environment variable. To generate it, go here BEFORE running this image:
#https://remotedesktop.google.com/headless
ARG CODE
ENV REMOTE_DESKTOP_CODE=$CODE

#install dependencies
RUN apt-get update -y &&                              \
    apt-get install -y                                \
        curl xfce4 desktop-base xscreensaver

#download the Debian Linux Chrome Remote Desktop installation package
RUN curl -O https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && 	\
    apt install -y      					                                \
        --with-source=chrome-remote-desktop_current_amd64.deb   			 	\
        chrome-remote-desktop
 
#configure Chrome Remote Desktop to use Xfce
RUN echo "xfce4-session" > ~/.chrome-remote-desktop-session

#disable display manager -- no display connected so it won't start
RUN systemctl disable lightdm.service

#OPTIONAL: install Google Chrome on the container
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&    	\
    apt install -y google-chrome-stable                                                		\
        --with-source=google-chrome-stable_current_amd64.deb

RUN apt-get autoclean &&            \
    apt-get autoremove &&           \
    rm -rf /var/lib/apt/lists/*

CMD ["/opt/google/chrome-remote-desktop/start-host",                        \
    "--code=${REMOTE_DESKTOP_CODE}",                                        \
    "--redirect-url='https://remotedesktop.google.com/_/oauthredirect'",    \
    "--name=${NAME}"

EXPOSE 443 5522
