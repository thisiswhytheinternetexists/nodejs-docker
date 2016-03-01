# Use the base App Engine Docker image, based on debian jessie.
FROM gcr.io/google_appengine/base

# Install updates and dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates libkrb5-dev gcc make && \
    apt-get clean && rm /var/lib/apt/lists/*_*

RUN apt-get install -y -q ruby-dev

RUN gem install fpm

# Install the latest LTS release of nodejs
RUN mkdir /nodejs && curl https://nodejs.org/dist/v4.2.3/node-v4.2.3-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1
ENV PATH $PATH:/nodejs/bin

# Install semver, as required by the node version install script.
RUN npm install https://storage.googleapis.com/gae_node_packages/semver.tar.gz

# Add the node version install script
ADD install_node /usr/local/bin/install_node

# Set common env vars
ENV NODE_ENV production

WORKDIR /app

# start
CMD ["npm", "start"]
