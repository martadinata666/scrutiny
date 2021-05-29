FROM registry.gitlab.com/dedyms/sid-slim:rolling
ARG RELEASE
ARG ARCH
ENV SCRUTINY_VERSION=$RELEASE
RUN apt update && apt install --no-install-recommends -y smartmontools cron && apt clean && rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
RUN mkdir -p /home/$CONTAINERUSER/scrutiny/config && \
    mkdir -p /home/$CONTAINERUSER/scrutiny/web && \
    mkdir -p /home/$CONTAINERUSER/scrutiny/bin && \
    mkdir -p /home/$CONTAINERUSER/scrutiny/collector
WORKDIR /home/$CONTAINERUSER/scrutiny
COPY scrutiny.yaml /home/$CONTAINERUSER/scrutiny/config/scrutiny.yaml
COPY scrutiny.cron /etc/cron.d/scrutiny
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/$RELEASE/scrutiny-web-linux-$ARCH /home/$CONTAINERUSER/scrutiny/bin
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/$RELEASE/scrutiny-web-frontend.tar.gz /home/$CONTAINERUSER/scrutiny/web
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/0.3.12/scrutiny-collector-metrics-linux-amd64 /home/$CONTAINERUSER/scrutiny/collector
RUN chmod +x /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux-$ARCH && \
    chmod +x /home/$CONTAINERUSER/scrutiny/bin/scrutiny-collector-metrics-linux-amd64 && \
    tar xvzf /home/$CONTAINERUSER/scrutiny/web/scrutiny-web-frontend.tar.gz --strip-components 1 -C /home/$CONTAINERUSER/scrutiny/web && \
    rm /home/$CONTAINERUSER/scrutiny/web/scrutiny-web-frontend.tar.gz

CMD /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux-amd64 start --config /home/$CONTAINERUSER/scrutiny/config/scrutiny.yaml
