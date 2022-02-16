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
task :e2e do
  ruby "./test/e2e_test_recon_tools.rb"
end

desc "Run tests"
task :default => :test

desc 'builds a local preview of the documentation'
task "docs_preview" => "out/docs"

task "out/docs" => "src/docs/" do |t|
  adoc_opts = {
    "--require" => "asciidoctor-diagram",
    "--source-dir" => t.source,
    "--destination-dir" => t.name
  }.flatten.join(' ')
  sh "bundle exec asciidoctor #{adoc_opts} **/*.adoc"
end
