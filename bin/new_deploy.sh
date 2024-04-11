#!/bin/sh -e

bundle exec puma -e production -C config/puma.rb -b unix:///tmp/smash-it.sock -w 2
