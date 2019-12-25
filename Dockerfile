FROM ubuntu:14.04

# 32bit
RUN dpkg --add-architecture i386

# update 
RUN apt-get update && apt-get -y upgrade

# install
RUN set -x && apt-get update \
    && apt-get install -y \
    git \
    xz-utils \
    u-boot-tools \
    make g++ libboost-all-dev \
    wget curl unzip \
    tk-dev ncurses-dev \
    build-essential texinfo libgmp-dev libmpfr-dev libppl-dev libcloog-ppl-dev \
    jlha-utils \
    wine1.6-i386 \
    apt-utils software-properties-common \
    language-pack-ja-base language-pack-ja

# locale
ENV LANG=ja_JP.UTF-8

# user add
RUN mkdir /home/etrobo \
    && useradd -d /home/etrobo etrobo \
    && chown -R etrobo:etrobo /home/etrobo/
USER etrobo
WORKDIR /home/etrobo

# git clone
RUN git clone https://github.com/gmsanchez/nxtOSEK.git

WORKDIR /etrobo/nxtOSEK
RUN sh ./build_arm_toolchain.sh 2>&1 | tee ./build_arm_toolchain.sh.log

# nxtosek install
RUN wget http://sourceforge.net/projects/lejos-osek/files/nxtOSEK/nxtOSEK_v218.zip
#RUN wget http://www.toppers.jp/download.cgi/osek_os-1.1.lzh
COPY osek_os-1.1.lzh /etrobo/nxtOSEK
RUN unzip nxtOSEK_v218.zip
RUN lha -e osek_os-1.1.lzh
RUN mv toppers_osek/sg/sg.exe ./nxtOSEK/toppers_osek/sg
RUN rm -rf toppers_osek

RUN cp ecrobot.mak ./nxtOSEK/ecrobot/
RUN cp ecrobot++.mak ./nxtOSEK/ecrobot/
RUN cp tool_gcc.mak ./nxtOSEK/ecrobot/

WORKDIR /etrobo/nxtOSEK/nxtOSEK/ecrobot

