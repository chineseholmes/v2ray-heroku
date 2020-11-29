FROM alpine:3.5

ADD configure.sh /configure.sh

RUN apk add --update tzdata --no-cache --virtual .build-deps ca-certificates curl unzip \
 && chmod +x /configure.sh
 
ENV TZ=Asia/Shanghai
ENV FRP_VERSION 0.34.2

CMD /configure.sh
