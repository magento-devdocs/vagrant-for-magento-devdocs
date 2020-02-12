#!/usr/bin/env bash

# Customization parameters.
RUBY_VERSION=2.6
RVM_PATH=/usr/local/rvm
GEMS=bundler
# Replace 'none' with your token here if you have reading access to private magento repositories
TOKEN=none

# Get information on the newest versions of Ubuntu packages
sudo apt-get update

# Install Ubuntu packages
sudo apt-get install -y git libcurl4-openssl-dev

# Install Ruby
if [ ! -e $RVM_PATH ]; then
	gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	curl -sSL https://get.rvm.io | bash -s
fi

source $RVM_PATH/scripts/rvm

# Set up the default ruby version
rvm use --install $RUBY_VERSION --default

# Install gems
gem install $GEMS

# Clean up
sudo apt-get autoremove -y

# Clone the 'devdocs' repo from GitHub in a shared directory
cd /vagrant/
git clone https://github.com/magento/devdocs.git

# Note: To avoid entering your user name and password every time you push, you can either use the SSH protocol

# Install gems and dependencies from Gemfile.
cd /vagrant/devdocs
# Use system libraries to build the nokogiri extensions to decrease the gem installation time
bundle config build.nokogiri --use-system-libraries
# Install gems from Gemfile
bundle install
# Provide the 'token' shell variable to enable cloning by https 
token=$TOKEN rake init

# Run Jekyll to generate the devdocs site on localhost:40000
#    bin/jekyll serve --host=0.0.0.0
