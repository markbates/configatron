require 'bundler'  
Bundler::GemHelper.install_tasks

Rake::TestTask.new(:default) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end