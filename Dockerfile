FROM centos:7
WORKDIR /usr/local

ADD wex5.tar.gz /usr/local/

COPY wex5/startup.sh /usr/local/startup.sh
COPY wex5/mysql/bin/startup.sh /usr/local/mysql/bin/startup.sh
COPY wex5/apache-tomcat/bin/catalina.sh /usr/local/apache-tomcat/bin/catalina.sh
COPY wex5/apache-tomcat/config/context.xml /usr/local/apache-tomcat/config/context.xml

RUN yum install -y libaio
RUN useradd mysql

EXPOSE 8080

CMD /usr/local/startup.sh
