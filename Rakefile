require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rack-counter"
    gem.summary = %Q{Hit counter Rack Middleware using Memcached}
    gem.description = gem.summary
    gem.email = "<ddollar@gmail.com>"
    gem.homepage = "http://github.com/ddollar/rack-counter"
    gem.authors = ["David Dollar"]

    gem.add_development_dependency "rack-test"
    gem.add_development_dependency "rspec"

    gem.add_dependency "memcache-client"
    gem.add_dependency "rack"
    gem.add_dependency "system_timer"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end