FROM ubuntu:18.04

RUN set -x \
        && apt-get update \
        && apt-get install --no-install-recommends --no-install-suggests -y\
        vim  \
        && apt-get remove --purge --auto-remove -y apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/* 


EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/bin/bash"]
