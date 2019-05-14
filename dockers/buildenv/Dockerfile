
# base image
FROM ubuntu:18.04

# MAINTAINER
MAINTAINER qingshenlwy@163.com

# Install the softwares
RUN apt-get update
RUN apt-get install -y maven docker.io lsof zip unzip 

# Update the SonarQube env
ADD settings.xml /etc/maven/

WORKDIR /build/
