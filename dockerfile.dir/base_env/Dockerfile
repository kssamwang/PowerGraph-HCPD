# Image build : docker build -t kssamwang/powergraph-base
FROM ubuntu:16.04 as base
FROM base as base-amd64

RUN echo "root:xya1234" | chpasswd

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

RUN rm -f /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted" >> /etc/apt/sources.list
RUN echo  "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted" >> /etc/apt/sources.list
RUN echo  "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial universe" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo  "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted" >> /etc/apt/sources.list
RUN echo  "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe" >> /etc/apt/sources.list
RUN echo  "deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install gcc g++ build-essential libopenmpi-dev openmpi-bin default-jdk cmake zlib1g-dev git libboost-all-dev ssh -y
