FROM alpine:edge

ENV XIGEN_DOCKER_COMPOSE_VERSION 1.24.0

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing font-noto-emoji

RUN apk add tmux zsh git curl vim shadow openssh-client gnupg rsync \
  && adduser -D -u 1000 xigen \
  && addgroup docker \
  && usermod -a -G docker xigen

USER xigen
WORKDIR /home/xigen

RUN git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
  && git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions

COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY .* /home/xigen/
COPY image-bin /home/xigen/bin

USER root
RUN chown -Rvf xigen:xigen /home/xigen
RUN chmod -Rvf 554 /home/xigen/bin/*

USER xigen
ENTRYPOINT ["tmux", "-u"]
