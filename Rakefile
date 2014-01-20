task :default => [:test]

task :test do
  require 'fileutils'

  Dir.chdir('tests') do
    output_dir = 'output'
    FileUtils.mkdir_p output_dir
    ruby '.unit_tests.rb'
    FileUtils.rm_rf output_dir
  end
end

desc 'Compile baseline CSS'
task :compile do
  require 'compass'
  require 'compass/exec'

  Dir.chdir('tests') do
    Compass.add_configuration 'config.rb'
    Compass.configuration.project_path = Dir.pwd
    # Compile into baseline directory instead of test output directory
    Compass.configuration.css_dir = 'controls'
    Compass.compiler.clean!
    Compass.compiler.run
  end
end
