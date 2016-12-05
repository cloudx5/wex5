FROM tomcat:6-jre8

ENV POSTGREST_VERSION 0.3.2.0

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		git \
		tar xz-utils wget libpq-dev && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##RUN wget http://github.com/begriffs/postgrest/releases/download/v${POSTGREST_VERSION}/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz && \
COPY postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz /tmp/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz
RUN tar --xz -xvf /tmp/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz && \
    mv postgrest /usr/local/bin/postgrest && \
    rm /tmp/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz

COPY tomcat/ "${CATALINA_HOME}/"
