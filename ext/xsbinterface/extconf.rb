# This script runs configure, then make.

# Get the current directory, and the directory I want to work in.
running_directory = Dir.pwd
ext_directory = File.expand_path(File.dirname(__FILE__))

Dir.chdir(ext_directory)

coms_to_run = ['./configure', 'make']

coms_to_run.each do |a_command|
  return_status = system(a_command)
  raise "#{a_command} failed! Check the output for info." unless return_status
end

Dir.chdir(running_directory)
