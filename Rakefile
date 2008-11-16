# Copyright 2008 David Vollbracht & Philippe Hanrigou

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rubygems'

CLEAN.include '**/*.o'
CLEAN.include '**/*.so'
CLEAN.include '**/*.bundle'
CLOBBER.include '**/*.log'
CLOBBER.include '**/Makefile'
CLOBBER.include '**/extconf.h'

SYSTEM_TIMER_VERSION = "1.1"
SYSTEM_TIMER_GEM_NAME = "SystemTimer"

desc 'Default: run unit tests.'
task :default => :test

desc 'Install the gem into the local gem repository' 
task :install => 'package' do
  sh "gem install ./pkg/#{SYSTEM_TIMER_GEM_NAME}-#{SYSTEM_TIMER_VERSION}.gem"
end

desc 'Test SystemTimer'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
task :test => 'ext/system_timer/libsystem_timer_native.so'

desc 'Generate documentation for SystemTimer.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SystemTimer'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

file 'ext/system_timer/Makefile' => 'ext/system_timer/extconf.rb' do
  Dir.chdir('ext/system_timer') do
    ruby 'extconf.rb'
  end
end

file 'ext/system_timer/libsystem_timer_native.so' => 'ext/system_timer/Makefile' do
  Dir.chdir('ext/system_timer') do
    pid = fork { exec "make" }
    Process.waitpid pid
  end
  fail "Make failed (status #{m})" unless $?.exitstatus == 0
end

specification = Gem::Specification.new do |s|
  s.name = SYSTEM_TIMER_GEM_NAME
  s.summary = "Set a Timeout based on signals, which are more reliable than Timeout. Timeout is based on green threads."
  s.version = SYSTEM_TIMER_VERSION
  if ENV['PACKAGE_FOR_WIN32'] || PLATFORM['win32'] 
    s.platform = Gem::Platform.new "mswin32"
    s.files = FileList['lib/system_timer_stub.rb']
    s.autorequire = "system_timer_stub"
  else
    s.platform = Gem::Platform::RUBY
    s.files = [ "COPYING", "LICENSE", "ChangeLog"] + 
                FileList['ext/**/*.c'] + 
                FileList['ext/**/*.rb'] + 
                FileList['lib/**/*.rb'] + 
                FileList['test/**/*.rb']
    s.autorequire = "system_timer"
    s.extensions = ["ext/system_timer/extconf.rb"]
  end  
  s.require_path = "lib"
  s.rdoc_options << '--title' << 'SystemTimer' << '--main' << 'README' << '--line-numbers'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README']
	s.test_file = "test/all_tests.rb"
end
  
Rake::GemPackageTask.new(specification) do |package|
	 package.need_zip = false
	 package.need_tar = false
end

desc "Publish RDoc on Rubyforge website"
task :publish_rdoc => :rdoc do
  sh "scp -r rdoc/* #{ENV['USER']}@rubyforge.org:/var/www/gforge-projects/systemtimer"
end
