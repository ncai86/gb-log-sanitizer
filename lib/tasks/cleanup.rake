namespace :cleanup do
  desc "TODO"
  task :clear_tmp => :environment do
  	FileUtils.rm_rf(Dir.glob('txlogs/*'))
  end

end
