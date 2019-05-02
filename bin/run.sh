
DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GID=
DOCER_GROUP_ADD="docker"

if [ -x "$(command -v getent)" ]; then
  DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
  DOCER_GROUP_ADD=$(getent group docker | cut -d: -f3)
fi

XIGEN_HOST_USER=$(whoami)
XIGEN_HOST_USERID=$(id -u)
XIGEN_HOST_GROUPID=$(id -g)

export XIGEN_CODE_DIR=${XIGEN_CODE_DIR:-git}
export XIGEN_CODE_PATH="$HOME/$XIGEN_CODE_DIR"

docker run -it \
  --user $XIGEN_HOST_USERID:$XIGEN_HOST_GROUPID \
  --group-add $DOCER_GROUP_ADD \
  -e XIGEN_HOST_USER=$XIGEN_HOST_USER \
  -e XIGEN_HOST_USERID=$XIGEN_HOST_USERID \
  -e XIGEN_HOST_GROUPID=$XIGEN_HOST_GROUPID \
  -e DOCKER_HOST=$DOCKER_HOST \
  -e DOCKER_SOCKET=$DOCKER_SOCKET \
  -e DOCKER_GID=$DOCKER_GID \
  -v /var/run/docker.sock:/var/run/docker.sock:rw \
  -v $HOME/data:/home/xigen/data \
  -v $XIGEN_CODE_PATH:/home/xigen/$XIGEN_CODE_DIR \
  -v $HOME/.ssh:/home/xigen/.ssh \
  -v $HOME/.gitconfig:/home/xigen/.gitconfig \
  -v $HOME/.zsh_aliases:/home/xigen/.zsh_aliases_local \
  -v $HOME/.zsh_history:/home/xigen/.zsh_history \
  xigen/developer-shell:latest
