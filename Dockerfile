# docker rm --force $(docker ps -a | grep -v CONTAINER | awk '{print $1}')
# docker build -t yandex-disk .; docker run -d -v /tmp/yandex:/root/yandex-disk yandex-disk
# docker exec -it $(docker ps | grep "yandex-disk" | awk '{print $1}') bash

FROM phusion/baseimage:0.9.17
MAINTAINER Dmitry Sandalov <dmitry@sandalov.org>

ENV yandex_pass=secret
ENV yandex_user=user

RUN curl -x proxy.com:80 -O http://repo.yandex.ru/yandex-disk/yandex-disk_latest_amd64.deb
RUN dpkg -i yandex-disk_latest_amd64.deb

RUN yandex-disk --proxy=https,proxy.com,80 token --password $yandex_pass $yandex_user

VOLUME ["/root/yandex-disk"]
CMD ["/usr/bin/yandex-disk", "start", "--dir", "/root/yandex-disk", "-D", "--proxy=https,proxy.com,80"]
