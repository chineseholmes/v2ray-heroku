FROM alpine:3.5

ADD configure.sh /configure.sh

RUN apk add --update tzdata --no-cache --virtual .build-deps ca-certificates curl unzip \
 && chmod +x /configure.sh
 
ENV TZ=Asia/Shanghai
ENV FRP_VERSION 0.34.2

RUN wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && tar -xf frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && mkdir /frpc \
    && cp frp_${FRP_VERSION}_linux_amd64/frpc* /frpc/ \
    && rm -rf frp_${FRP_VERSION}_linux_amd64*

RUN rm -rf /var/cache/apk/*

CMD /configure.sh
