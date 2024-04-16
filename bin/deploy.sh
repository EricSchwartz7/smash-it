#!/bin/sh -e

echo "Pulling latest from git..."
git pull

echo "Installing gems..."
bundle install

echo "Database migrations..."
bundle exec rake db:migrate RAILS_ENV=production

echo "Compiling assets..."
bundle exec rake assets:precompile

echo "Puma phased restarting..."
bundle exec pumactl phased-restart
