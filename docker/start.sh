#!/bin/bash

set -e
cd /app
apt-get update
apt-get install -y --no-install-recommends nodejs npm
npm install --global yarn
yarn install
gem install bundler
bundle config set without "test development"
bundle config set path "/app/vendor/bundle-$(ruby -e 'puts RUBY_VERSION')"
bundle install
bundle exec rake assets:precompile assets:clean
bundle exec rake db:prepare
bundle exec puma -p 3000 -S tmp/puma.state
