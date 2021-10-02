require 'rake/testtask'
require './lib/recon_tools'

task :test do
  Rake::TestTask.new do |t|
    t.pattern = 'test/**/test_*.rb'
    #t.libs << 'test'
    t.verbose = true
  end
end

desc "Run e2e Test Manually"
task :e2e2 do
  ruby "./test/e2e_test_recon_tools.rb"
end

desc "Run tests"
task :default => :test
