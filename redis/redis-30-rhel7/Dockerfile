FROM centos:centos7

LABEL io.k8s.description="Redis is an in-memory data structure store, used as database, cache and message broker" \
      io.k8s.display-name="Redis 3.0.5" \
      io.openshift.expose-services="6379:redis" \
      io.openshift.tags="database,cache,redis,redis30"


EXPOSE 6379

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r redis && useradd -r -g redis redis

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN if [ $(uname -m) == "x86_64" ]; then ARCH=amd64; else ARCH=i686; fi \
	&& curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$ARCH" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$ARCH.asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

ENV REDIS_VERSION 3.0.5
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.0.5.tar.gz
ENV REDIS_DOWNLOAD_SHA1 ad3ee178c42bfcfd310c72bbddffbbe35db9b4a6

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN buildDeps='gcc glibc-devel make' \
	&& set -x \
	&& yum -y --setopt=tsflags=nodocs install gettext  \
	&& yum -y --setopt=tsflags=nodocs install $buildDeps  \
	&& mkdir -p /usr/src/redis \
	&& curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz \
	&& echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
	&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
	&& rm redis.tar.gz \
	&& make -C /usr/src/redis \
	&& make -C /usr/src/redis install \
	&& rm -r /usr/src/redis \
	&& yum -y --setopt=tsflags=nodocs remove $buildDeps \
	&& yum clean all -y

RUN mkdir /data && chown redis:redis /data
#VOLUME /data
WORKDIR /data

COPY redis-server-entrypoint.sh /entrypoint.sh
COPY redis_template.conf /usr/local/etc/redis_template.conf

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "redis-server", "/usr/local/etc/redis.conf" ]

