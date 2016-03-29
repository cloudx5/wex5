FROM centos:7
WORKDIR /usr/local

ADD wex5.tar.gz /usr/local/

COPY wex5/* /usr/local

RUN yum install -y libaio
RUN useradd mysql

EXPOSE 8080

CMD /usr/local/startup.sh
