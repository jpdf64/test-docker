FROM ubuntu:18.04

USER root

RUN apt-get update && apt-get install wget -y \
	&& apt-get install -y gnupg \
	&& apt-get install openjdk-8-jdk -y \
	&& apt-get install unzip -y \
	&& apt-get install -y curl


RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo "deb http://pkg.jenkins.io/debian-stable binary/" \
	| tee -a /etc/apt/sources.list.d/jenkins.list
RUN apt-get update && apt-get install jenkins -y


ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_UC https://updates.jenkins.io

COPY install-plugins.sh /usr/local/bin/install-plugins.sh
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod +x /usr/local/bin/install-plugins.sh
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
