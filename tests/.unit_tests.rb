require 'compass'
require 'compass/exec'
require 'test/unit'
require 'diffy'
require 'colorize'
require 'pathname'

class TestCompassOutput < Test::Unit::TestCase

  Compass.add_configuration 'config.rb'
  Compass.configuration.project_path = Dir.pwd

  # Remove all current Diff files
  Dir.glob("#{Dir.pwd}/output/**/*.css.diff").each { |f| File.delete(f) }

  Compass.compiler.sass_files.each do |sass_file|
    test_name = File.basename(sass_file, '.*')

    define_method "test_#{test_name}_compile " do
      # Compiled CSS file path
      test_file_pwd = Compass.compiler.corresponding_css_file(sass_file)

      # Relative path of compiled CSS file from Tests directory
      relative_pwd = Pathname.new(test_file_pwd).relative_path_from(Pathname.new("#{Dir.pwd}/output")).to_s

      # Control files path
      control_file_pwd = "#{Dir.pwd}/controls/" + relative_pwd

      # The base path of the sub folders, making the folders if needed
      base_pwd = relative_pwd.sub(File.basename(relative_pwd), '')
      FileUtils.mkdir_p "#{Dir.pwd}/output/#{base_pwd}"

      # Compiles Sass file
      Compass.compiler.compile sass_file, test_file_pwd  # Raises exception upon error

      begin
        # Assert that our test output matches our control output
        passed = assert FileUtils.compare_file(test_file_pwd, control_file_pwd), "Compiled output for #{File.basename(sass_file)} does not match control output!".red
      ensure
        # If there is a failure, generate a diff of the files and put it with the compiled file
        if !passed
          test_file = File.open(test_file_pwd).read;
          control_file = File.open(control_file_pwd).read;
          diff_pwd = "#{Dir.pwd}/output/#{relative_pwd}.diff"
          diff_content = Diffy::Diff.new(control_file, test_file, :include_diff_info => true)

          File.open(diff_pwd, 'w') { |f| f.write(diff_content.to_s(:text)) }

      	  puts "Control->Compiled diff output to ".yellow + " tests/output/#{relative_pwd}.diff ".colorize( :color => :blue, :background => :black)
        end
      end
    end
  end
end

