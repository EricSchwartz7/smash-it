# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
set :output, "/var/www/smash-it/cron_log.log"

every 1.day, at: '10:08 am' do
  runner "User.first.ai_image_email"
end

# Learn more: http://github.com/javan/whenever
