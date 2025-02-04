FROM debian

ARG USER
ENV USER=${USER:-code-sandbox}

RUN apt update && apt install wget sudo tar curl -y

RUN adduser $USER --disabled-password --gecos ""
RUN echo "$USER:$USER" | chpasswd
RUN echo "$USER ALL=(ALL) PASSWD: ALL" > /etc/sudoers.d/$USER

RUN mkdir code-server
WORKDIR /code-server

RUN wget -O /tmp/code-server.tar.gz $(curl -s https://api.github.com/repos/coder/code-server/releases/latest | grep browser_download_url | grep amd64.tar.gz | cut -d '"' -f 4)
RUN tar xvf /tmp/code-server.tar.gz --strip-components 1

RUN mkdir /sandbox
RUN chown $USER:$USER /sandbox
USER $USER

WORKDIR /home/$USER
ENTRYPOINT ["/code-server/bin/code-server", "--bind-addr=0.0.0.0", "--auth=none"]
