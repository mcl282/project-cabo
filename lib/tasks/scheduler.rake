#run rake TASK in CLI and the task will run

desc "This task is called by the Heroku scheduler add-on"
task :works => :environment do
  puts "This is working!!!!"
end

desc "Refrsh Dwolla app token"
task :refresh_dwolla_app_token => :environment do
#  current_token = TokenData.refresh_token
#  puts current_token.access_token
  DwollaAppToken.get_token
  
end

