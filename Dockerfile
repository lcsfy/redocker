FROM node:8
ARG NPM_TOKEN


# ------------------------
# SSH Server support
# ------------------------
RUN apt-get update \
  && apt-get install -y --no-install-recommends openssh-server \
  && echo "root:Docker!" | chpasswd \
  && mkdir -p /home/LogFiles \
  && echo "cd /home" >> /etc/bash.bashrc 

#Copy the sshd_config file to its new location
COPY sshd_config /etc/ssh/

COPY package.json package.json

RUN npm config set _auth ${NPM_TOKEN}
RUN npm config set always-auth true
RUN npm config set email xxxxxxxx
RUN npm config set registry xxxxxxx
RUN npm install --production

RUN service ssh start

RUN npm install -g pm2

COPY . .

EXPOSE 2222 1337

CMD ["pm2-docker", "server.js"]