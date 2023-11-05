# Docker file for Ubuntu with OpenJDK 18 and Tomcat 9.
FROM ubuntu:latest
LABEL maintainer="Karl Hill <karl.hill@nasa.gov>"

# Set environment variables
ENV TOMCAT_VERSION 9.0.71
ENV CATALINA_HOME /usr/local/tomcat
ENV JAVA_HOME /usr/lib/jvm/java-18-openjdk-amd64
ENV PATH $CATALINA_HOME/bin:$PATH

# Install JDK & wget packages.
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-18-jdk wget curl unzip

# Install and configure Tomcat.
RUN mkdir -p $CATALINA_HOME/webapps/
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-${TOMCAT_VERSION}/* $CATALINA_HOME
RUN rm -rf /tmp/apache-tomcat-${TOMCAT_VERSION}
RUN rm -rf /tmp/tomcat.tar.gz

# Install art
WORKDIR files
COPY files/ .
RUN unzip -q art-7.12.zip \
	&& cp art-7.12/art.war $CATALINA_HOME/webapps/. \
	&& rm -rf art-7.12*

# RUN curl https://kumisystems.dl.sourceforge.net/project/art/art/7.12/art-7.12.zip -o /tmp/art-7.12.zip
# RUN cd /tmp && unzip -q art-7.12.zip
# RUN cp /tmp/art-7.12/art.war $CATALINA_HOME/webapps/.
# RUN rm -rf /tmp/art-7.12*

#Add a user ubuntu with UID 1001
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu && \
   chown -R ubuntu:root $CATALINA_HOME && \
   chgrp -R 0 $CATALINA_HOME && \
   chmod -R g=u $CATALINA_HOME

#Specify the user with UID
USER 1001

EXPOSE 8080

# Start Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
