FROM registry.gitlab.com/dedyms/sid-slim:latest AS tukang
ARG RELEASE
ARG ARCH
USER $CONTAINERUSER
RUN mkdir -p /home/$CONTAINERUSER/scrutiny/config && \
    mkdir -p /home/$CONTAINERUSER/scrutiny/web && \
    mkdir -p /home/$CONTAINERUSER/scrutiny/bin
WORKDIR /home/$CONTAINERUSER/scrutiny
COPY scrutiny.yaml /home/$CONTAINERUSER/scrutiny/config/scrutiny.yaml
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/$RELEASE/scrutiny-web-linux-$ARCH /home/$CONTAINERUSER/scrutiny/bin
ADD --chown=$CONTAINERUSER:$CONTAINERUSER https://github.com/AnalogJ/scrutiny/releases/download/$RELEASE/scrutiny-web-frontend.tar.gz /home/$CONTAINERUSER/scrutiny/web
RUN chmod +x /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux-$ARCH && \
    tar xvzf /home/$CONTAINERUSER/scrutiny/web/scrutiny-web-frontend.tar.gz --strip-components 1 -C /home/$CONTAINERUSER/scrutiny/web && \
    rm /home/$CONTAINERUSER/scrutiny/web/scrutiny-web-frontend.tar.gz
#VOLUME /home/$CONTAINERUSER/scrutiny/config
#CMD /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux-amd64 start --config /home/$CONTAINERUSER/scrutiny/config/scrutiny.yaml


FROM registry.gitlab.com/dedyms/sid-slim:latest
ARG RELEASE
ARG ARCH
ENV ARCH=$ARCH
ENV SCRUTINY_VERSION=$RELEASE
USER $CONTAINERUSER
COPY --from=tukang /home/$CONTAINERUSER/scrutiny/ /home/$CONTAINERUSER/scrutiny/
VOLUME /home/$CONTAINERUSER/scrutiny/config
CMD /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux-$ARCH start --config /home/$CONTAINERUSER/scrutiny/config/scrutiny.yaml
