FROM ubuntu:trusty
MAINTAINER https://github.com/cloudfoundry/cf-mysql-release

ENV DEBIAN_FRONTEND=noninteractive

# libmysqlclient-dev is used for pre-packaging cf-mysql-broker
# libfontconfig1-dev etc. are required by phantomjs
# nodejs, npm and libicu52 are for switchboard ui
RUN \
      apt-get update && \
      apt-get -y install --fix-missing \
            build-essential \
            curl \
            git \
            libreadline6 \
            libreadline6-dev\
            wget \
            unzip \
            libmysqlclient-dev \
            nodejs \
            npm \
            libicu52 \
            libfontconfig1-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev \
            jq \
            mysql-client \
            python-dev \
            apt-transport-https \
            software-properties-common \
      && \
      apt-get clean

RUN \
    apt-add-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -cs)-backports universe" \
    && apt-get -qq update \
    && apt-get -t $(lsb_release -cs)-backports install shellcheck

RUN \
    apt-add-repository "deb https://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update \
    && apt-get -y install google-cloud-sdk

# Alias nodejs as node for switchboard ui
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install ruby-install
RUN curl https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.5.0 | tar xvz -C /tmp/ && \
          cd /tmp/ruby-install-0.5.0 && \
          make install

ENV DOCKER_RUBY_VERSION 2.3.1

# Install Ruby
RUN ruby-install ruby ${DOCKER_RUBY_VERSION} -- --disable-install-rdoc

# Add ruby to PATH
ENV PATH $PATH:/home/root/.gem/ruby/${DOCKER_RUBY_VERSION}/bin:/opt/rubies/ruby-${DOCKER_RUBY_VERSION}/lib/ruby/gems/${DOCKER_RUBY_VERSION}/bin:/opt/rubies/ruby-${DOCKER_RUBY_VERSION}/bin

# Install gems
RUN /opt/rubies/ruby-${DOCKER_RUBY_VERSION}/bin/gem install bosh_cli --no-rdoc --no-ri && \
          /opt/rubies/ruby-${DOCKER_RUBY_VERSION}/bin/gem install bundler --no-rdoc --no-ri

# Install gobosh cli
RUN \
  wget -q https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-0.0.145-linux-amd64 -O /usr/local/bin/gobosh && \
  chmod +x /usr/local/bin/gobosh

# Phantomjs is used by switchboard ui tests and dashboard acceptance tests
RUN wget https://github.com/Pyppe/phantomjs2.0-ubuntu14.04x64/raw/master/bin/phantomjs && \
          chmod +x phantomjs && \
          mv phantomjs /usr/bin/phantomjs

# Install cf cli
RUN curl 'https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases/v6.22.2/cf-cli_6.22.2_linux_x86-64.tgz'| tar xvz -C /bin

# Install go
RUN curl https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz | tar xvz -C /usr/local/

# Add golang environment variables
ENV GOPATH /usr/local/go
ENV PATH $PATH:/usr/local/go/bin

# Install spiff
RUN wget -O /tmp/spiff.zip https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip
RUN unzip /tmp/spiff.zip -d /tmp/ && mv /tmp/spiff $GOPATH/bin/

# Add workspace directory
RUN mkdir -p /root/workspace && ln -s /root/workspace /workspace

# Tell ssh to ignore fingerprints
RUN mkdir -p /root/.ssh
RUN echo "Host * \n\tStrictHostKeyChecking no \n\tUserKnownHostsFile=/dev/null" >> /root/.ssh/config

# Install aws cli
RUN wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py && \
          python /tmp/get-pip.py && \
          rm /tmp/get-pip.py && \
          pip install awscli

# Install consul
RUN \
  wget -q https://releases.hashicorp.com/consul/0.5.2/consul_0.5.2_linux_amd64.zip -P /tmp/ && \
  unzip /tmp/consul_0.5.2_linux_amd64.zip -d /usr/local/bin && \
  rm /tmp/consul_0.5.2_linux_amd64.zip

#install gorgeous gem
RUN gem install gorgeous

# Install terraform
RUN wget 'https://releases.hashicorp.com/terraform/0.7.13/terraform_0.7.13_linux_amd64.zip' \
  --quiet \
  --output-document /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/local/bin/ && \
  chmod +x /usr/local/bin/terraform && \
  rm /tmp/terraform.zip
