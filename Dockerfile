FROM ubuntu:trusty

# Set the locale
ENV DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

# Install updates and dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y -q wget python build-essential ca-certificates gcc make ruby ruby-dev git git-core libfreetype6 libicu-dev libpng-dev libjpeg-dev flex bison gperf libssl-dev

# install nodejs
RUN \
  cd /tmp && \
  wget https://nodejs.org/dist/v4.3.2/node-v4.3.2-linux-x64.tar.gz && \
  tar -C /usr/local --strip-components 1 -xzf node-v4.3.2-linux-x64.tar.gz && \
  rm -f /tmp/node-v4.3.2-linux-x64.tar.gz && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc && \
  npm install -g npm


RUN gem install fpm package_cloud

RUN npm install -g nexe grunt grunt-cli

#ENV PHANTOM_JS_TAG 2.0.0

#RUN git clone https://github.com/ariya/phantomjs.git /tmp/phantomjs && \
#  cd /tmp/phantomjs && git checkout $PHANTOM_JS_TAG && \
#  ./build.sh --confirm && mv bin/phantomjs /usr/local/bin && \
#  rm -rf /tmp/phantomjs

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*