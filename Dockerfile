FROM node:alpine

RUN apk update && apk upgrade && apk --update add \
    ruby ruby-dev build-base ruby-irb ruby-rake libffi-dev ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
    libstdc++ tzdata bash ca-certificates \
    &&  echo 'gem: --no-document' > /etc/gemrc \
    && gem install fpm package_cloud \
    && apk del build-base

RUN npm install -g nexe grunt grunt-cli