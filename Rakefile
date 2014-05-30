require 'bundler'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:default) do |t|
  t.libs = ["lib"]
  # t.warning = true
  t.verbose = true
  t.test_files = FileList['test/**/*.rb'].reject do |file|
    file.end_with?('_lib.rb') || file.include?('/_lib/')
  end
end
