FROM php:7.4.33-apache

ENV TYPECHO_VERSION=v1.2.0
ENV TYPECHO_URL="https://github.com/typecho/typecho/releases/download/${TYPECHO_VERSION}/typecho.zip"

RUN set -x \
  && mkdir -p /usr/src/typecho \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
  && wget -O /tmp/typecho.tar.gz "$TYPECHO_URL" \
  && tar -xzf /tmp/typecho.tar.gz -C /usr/src/typecho/ --strip-components=1 \
  && apt-get purge -y --auto-remove ca-certificates wget \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*

WORKDIR /var/www/html

COPY entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]