FROM ubuntu:bionic

RUN apt-get update; apt-get install -y rsync curl git supervisor rdiff-backup screen build-essential default-jre-headless
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN mkdir -p /usr/games
WORKDIR /usr/games
RUN git clone https://github.com/hexparrot/mineos-node.git minecraft
WORKDIR minecraft
RUN git config core.filemode false
RUN chmod +x service.js mineos_console.js generate-sslcert.sh webui.js
RUN npm install --unsafe-perm
RUN ln -s /usr/games/minecraft/mineos_console.js /usr/local/bin/mineos
RUN cp mineos.conf /etc/mineos.conf

RUN ./generate-sslcert.sh

RUN useradd minecraft
RUN echo "password\npassword\n" | passwd minecraft

EXPOSE 8443
EXPOSE 25565

CMD ["/usr/bin/node", "/usr/games/minecraft/webui.js"]
