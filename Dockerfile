FROM teddysun/xray:latest AS xray-bin

FROM envoyproxy/envoy:v1.31.10

ENV TZ=Asia/Shanghai
ENV SUPERVISOR_CONF_DIR=/etc/supervisor/conf.d

RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

COPY --from=xray-bin /usr/bin/xray /usr/local/bin/
COPY config.json /etc/xray.json
COPY envoy.yaml /etc/envoy/envoy.yaml
COPY supervisor.conf ${SUPERVISOR_CONF_DIR}/

RUN chmod +x /usr/local/bin/xray && \
    chmod 644 /etc/xray.json /etc/envoy/envoy.yaml

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
