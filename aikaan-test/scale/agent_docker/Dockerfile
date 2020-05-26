FROM alpine
RUN apk add --update supervisor net-tools
COPY patch/opt /opt
ENV AIKAAN_AGENT_INSTALL_DIR=/ AIKAAN_AGENT_CONFIG_DIR=
ENTRYPOINT ["/opt/aikaan/bin/supervisord", "-c" ,"/opt/aikaan/etc/aikaan_supervisord.conf"]
