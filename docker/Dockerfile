# Docker file of yocto-builder
# To build:
# docker image build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t yocto-builder .

# useful commands:
#
#  images      List images
#  ps          List containers
#  rm          Remove one or more containers
#  rmi         Remove one or more images


FROM ubuntu:22.04
ARG userid
ARG groupid
ARG username

###############################################################################
# Environment establish

RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username >/root/username 
# && echo "export USER="$username >>/home/$username/.gitconfig

# You can copy your gitconfig file by unmark these lines.
#COPY gitconfig /home/$username/.gitconfig
#RUN chown $userid:$groupid /home/$username/.gitconfig

ENV HOME=/home/$username
ENV USER=$username
# ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i

###############################################################################
# Fix: tzdata hangs during Docker image build
#   From: https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d

ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###############################################################################
RUN apt-get update 

###############################################################################
# Build tools for yocto IQ9100
#
#   https://docs.qualcomm.com/bundle/publicresource/topics/80-70018-254/github_workflow_unregistered_users.html?vproduct=1601111740013072&version=1.4


RUN apt install -y repo gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint xterm python3-subunit mesa-common-dev zstd liblz4-tool locales tar python-is-python3 file libxml-opml-simplegen-perl vim whiptail g++ libacl1

RUN apt-get install -y gcc-multilib 
RUN apt-get install -y libssl-dev libssl-ocaml-dev

#  configure: error: --with-openssl was given but OpenSSL could not be detected
 
###############################################################################
# https://github.com/crops/yocto-dockerfiles/blob/master/dockerfiles/ubuntu/ubuntu-22.04/ubuntu-22.04-base/Dockerfile

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gawk \
        wget \
        git-core \
        subversion \
        diffstat \
        unzip \
        sysstat \
        texinfo \
        build-essential \
        chrpath \
        socat \
        python3 \
        python3-pip \
        python3-pexpect \
        python3-virtualenv \
        xz-utils  \
        locales \
        cpio \
        screen \
        tmux \
        sudo \
        iputils-ping \
        python3-git \
        python3-jinja2 \
        libegl1-mesa \
        libsdl1.2-dev \
        pylint \
        xterm \
        iproute2 \
        fluxbox \
        tightvncserver \
        lz4 \
        zstd \
        file && \
            DEBIAN_FRONTEND=noninteractive apt-get install -y \
                gcc-multilib \
                g++-multilib

###############################################################################
COPY build-install-dumb-init.sh /
RUN  bash /build-install-dumb-init.sh && \
     rm /build-install-dumb-init.sh && \
     apt-get clean
 


###############################################################################
# Local setting.
RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Do not use Bitbake as root
USER $username







