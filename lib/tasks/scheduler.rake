#run rake TASK in CLI and the task will run
desc "This task is called by the Heroku scheduler add-on"
task :works => :environment do
  puts "This is working!!!!"
end

