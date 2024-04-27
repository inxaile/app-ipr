FROM ubuntu:20.04

RUN useradd -Mr haproxy

RUN apt-get update -y \
	&& apt-get install -y haproxy mysql-client \
	&& apt-get clean -y

RUN chown -R haproxy /etc/haproxy

EXPOSE 3306
EXPOSE 3307

USER haproxy

COPY --chown=haproxy configs/* /configs/

COPY --chown=haproxy entrypoint.sh /

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]