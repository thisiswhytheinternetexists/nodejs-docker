# Use the base App Engine Docker image, based on debian jessie.
FROM ubuntu:trusty

# Set the locale
ENV DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

# Install updates and dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates libkrb5-dev gcc make ruby ruby-dev && \
    apt-get clean && rm /var/lib/apt/lists/*_*

RUN gem install fpm package_cloud

# Install the latest LTS release of nodejs
RUN mkdir /nodejs && curl https://nodejs.org/dist/v4.2.3/node-v4.2.3-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1
ENV PATH $PATH:/nodejs/bin

RUN npm install -g nexe grunt

# start
CMD ["npm", "start"]
