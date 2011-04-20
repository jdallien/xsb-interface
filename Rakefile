require 'rubygems' rescue nil
require 'rake/testtask'

task :test

desc "Install the application"
task :install do
  ruby "install.rb"
end

Rake::TestTask.new do |t|
  #t.libs << "tests"
  t.pattern = 'tests/*_test.rb'
  t.verbose = true
end
