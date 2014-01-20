# Tests

The tests for this project are built using Navigator, a Ruby testing framework
for Sass with Compass. https://github.com/Team-Sass/navigator

## Building the test environment

Navigator works through Ruby, so you need to be running Ruby 1.8.7 or greater, and you to install [Bundler](http://bundler.io/) with `gem install bundler` or, for Mac OS X and other systems requiring administrative privileges, `sudo gem install bundler`.

Once Bundler is installed, run `bundle install` to install libraries required by this project.

## Running tests

Once you have everything installed, run `bundle exec rake` to run the tests. This will compile all of the files in your `tests/tests` files into CSS files and compare those files to the files in `tests/controls`. If any of your output file from your tests don't line up with your controls, you'll get a `.diff` file generated of the differences and you'll get a failed assertion. If your Sass won't compile, you'll get a failed assertion.

If you're working off of a known set of good output and you'd like to generate your controls quickly, you can run `bundle exec rake compile`.
