require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
RuboCop::RakeTask.new

task default: [:rubocop, :spec]

task :console do
  sh 'pry -r ./lib/influxer.rb'
end
