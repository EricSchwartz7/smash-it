#!/bin/sh -e

echo "compiling assets..."
bundle exec rake assets:precompile

echo "Puma phased restarting..."
bundle exec pumactl phased-restart
