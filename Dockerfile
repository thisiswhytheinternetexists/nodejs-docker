# Use the base App Engine Docker image, based on debian jessie.
FROM ubuntu:trusty

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
CMD ["/bin/bash"]

# Install updates and dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates libkrb5-dev gcc make ruby-full && \
    apt-get clean && rm /var/lib/apt/lists/*_*

# skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

RUN gem install fpm
RUN gem install package_cloud

# Install the latest LTS release of nodejs
RUN mkdir /nodejs && curl https://nodejs.org/dist/v4.2.3/node-v4.2.3-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1
ENV PATH $PATH:/nodejs/bin

# Install semver, as required by the node version install script.
RUN npm install https://storage.googleapis.com/gae_node_packages/semver.tar.gz
RUN npm install -g nexe

# Add the node version install script
# ADD install_node /usr/local/bin/install_node

# Set common env vars
ENV NODE_ENV production

WORKDIR /app

# start
CMD ["npm", "start"]
