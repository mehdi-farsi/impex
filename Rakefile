require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = %w(
    test/engine_test.rb
    test/lookup_test.rb
    test/version_test.rb
  )
end

task :default => :test
