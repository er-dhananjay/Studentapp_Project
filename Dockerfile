#taking ubuntu as a base image 
FROM ubuntu:22.04

#tag to the image
LABEL DEV="amit"

#installing dependancies java and unzip commmand
RUN apt-get update -y && \
    apt-get install unzip openjdk-11-jdk -y

#downloading apache tomcat server from internet
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.111/bin/apache-tomcat-9.0.111.zip /opt/

#changing working directory to /opt
WORKDIR /opt/

#now unzip the installation file
RUN unzip apache-tomcat-9.0.111.zip

#copying the .xml file to the /conf directory
COPY context.xml apache-tomcat-9.0.111/conf/
#adding .war and .jar files to apache directory
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war /opt/apache-tomcat-9.0.111/webapps/student.war
ADD https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar /opt/apache-tomcat-9.0.111/lib/mysql-connector.jar
RUN chmod +x /opt/apache-tomcat-9.0.111/bin/catalina.sh

EXPOSE 8080

CMD ["/opt/apache-tomcat-9.0.111/bin/catalina.sh","run"]
