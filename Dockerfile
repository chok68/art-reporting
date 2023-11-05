FROM tomcat:9.0.82-jdk21-temurin-jammy

RUN apt update \
	&& apt install curl unzip -y

RUN curl https://kumisystems.dl.sourceforge.net/project/art/art/7.12/art-7.12.zip -o art-7.12.zip \
	&& unzip -q art-7.12.zip \
	&& cp art-7.12/art.war ./webapps/.
