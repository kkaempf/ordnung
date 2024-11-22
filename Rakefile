require 'rubygems'
require 'find'
require 'rspec/core/rake_task'

task :clean_logs do
  File.delete "log/test.log" rescue nil
end

RSpec::Core::RakeTask.new(:test) do |task|
  task.rspec_opts = ["-c", "-f progress", "-r ./spec/test_helper.rb"]
  task.pattern    = 'spec/*_spec.rb'
end

task :default => [:clean_logs, :test]

task :doc do
  system "rdoc -o rdoc lib/**"
end

task :"doc-coverage" do
  system "rdoc -C lib/**"
end
