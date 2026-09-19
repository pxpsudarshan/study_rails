# -*- encoding: UTF-8 –*-
# Learn more: http://github.com/javan/whenever

set :output, "log/crontab.log"
env :PATH, ENV['PATH']
job_type :backup, 'cd :path && :environment_variable=:environment :task :output'

if @environment == 'production'
  every 1.day, at: '5:00 am', roles: [:app]  do
    backup "backup perform -t niho_backup -c config/config.rb"
  end
end
