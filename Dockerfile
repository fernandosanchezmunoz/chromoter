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
ENV CODE=""

#unprivileged user name
ENV USER="chromoter"
ENV PASSWD="changeme"

#PIN for this instance
ARG PIN="123456"
ENV PIN=$PIN

#install dependencies
RUN apt-get -qq -y update && 		                        \
    apt-get -qq -y install					\
        curl xfce4 desktop-base xscreensaver  > /dev/null

#download the Debian Linux Chrome Remote Desktop installation package
#OPTIONAL: install Google Chrome on the container
RUN curl -O https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && 	\
    curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&	\
    apt-get -y -qq install      					             		\
	./chrome-remote-desktop_current_amd64.deb 						\
	./google-chrome-stable_current_amd64.deb > /dev/null

#configure Chrome Remote Desktop to use Xfce
RUN echo "xfce4-session" > ~/.chrome-remote-desktop-session

#disable display manager -- no display connected so it won't start
RUN systemctl disable lightdm.service

RUN apt-get -qq autoclean  &&       \
    apt-get -qq autoremove  &&      \
    rm -rf /var/lib/apt/lists/*2

ADD startup.sh .

ENTRYPOINT ["./startup.sh"]
#ENTRYPOINT ["su", "-", "${USER}", "-c", "opt/google/chrome-remote-desktop/start-host", "--code=${CODE}", "--redirect-url=https://remotedesktop.google.com/_/oauthredirect", "--name=${NAME}"]

EXPOSE 443 5222
