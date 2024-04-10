#!/bin/bash -e

echo "building Tailwind CSS"
bundle exec rake tailwindcss:build

echo "Puma phased restarting..."
bundle exec pumactl phased-restart
