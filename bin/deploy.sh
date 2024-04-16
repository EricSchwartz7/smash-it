#!/bin/sh -e

echo "pulling latest from git"
git pull

echo "installing gems"
bundle install

echo "compiling assets..."
bundle exec rake assets:precompile

echo "Puma phased restarting..."
bundle exec pumactl phased-restart
