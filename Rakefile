#!/usr/bin/env ruby
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'rubygems'
begin
  require 'rakefile' # http://github.com/bendiken/rakefile
rescue LoadError => e
end
require 'rdf/spec'

desc "Build the rdf-spec-#{File.read('VERSION').chomp}.gem file"
task :build do
  sh "gem build .gemspec"
end
