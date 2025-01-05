FROM debian

RUN apt update && apt install wget sudo tar -y
ENV PORT=5408

RUN adduser code-sandbox \
  --disabled-password \
  --no-create-home \
  --gecos ""

RUN echo "code-sandbox:code-sandbox" | chpasswd
RUN echo "code-sandbox ALL=(ALL) PASSWD: ALL" > /etc/sudoers.d/code-sandbox

RUN mkdir code-server
WORKDIR /code-server

RUN wget -O /tmp/code-server.tar.gz https://github.com/coder/code-server/releases/download/v4.96.2/code-server-4.96.2-linux-amd64.tar.gz
RUN tar xvf /tmp/code-server.tar.gz --strip-components 1

RUN mkdir /sandbox
RUN chown code-sandbox:code-sandbox /sandbox
USER code-sandbox

WORKDIR /home/code-sandbox
ENTRYPOINT ["/code-server/bin/code-server", "--bind-addr=0.0.0.0", "--auth=none"]
