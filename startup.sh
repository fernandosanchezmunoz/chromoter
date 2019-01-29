#!/bin/bash
#TODO: check varaibles are defined, exit otherwise
useradd -ms /bin/bash ${USER}
echo ${USER}":"${PASSWD}|chpasswd
su - ${USER} -c \
   ' \
/opt/google/chrome-remote-desktop/start-host		                \
   --code=${CODE}		                     	                \
   --redirect-url="https://remotedesktop.google.com/_/oauthredirect"    \
   --name=${NAME}                                                       \
   '
