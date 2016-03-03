# Use the base App Engine Docker image, based on debian jessie.
FROM phusion/baseimage:0.9.18

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Set the locale
ENV DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

# Install updates and dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y -q wget python build-essential ca-certificates gcc make ruby ruby-dev git git-core

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

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*