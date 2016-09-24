namespace :impex do
  desc "Import all files"
  task :all => :environment do
    Impex::Engine.run
  end
end