# Use the base App Engine Docker image, based on debian jessie.
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
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential ca-certificates gcc make ruby ruby-dev nodejs npm git git-core && \
    apt-get clean && rm /var/lib/apt/lists/*_*

RUN gem install fpm package_cloud

RUN npm install -g nexe grunt