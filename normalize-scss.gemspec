# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'normalize-scss'

  s.summary     = %q{A Sass/Compass version of Normalize.css}
  s.description = %q{A Sass/Compass version of Normalize.css. This port tracks the parent project very closely.}

  s.homepage    = 'https://github.com/JohnAlbin/normalize.css-with-sass-or-compass'
  s.rubyforge_project =

  s.version     = '2.1.3'
  s.date        = '2013-11-03'
  s.licenses    = ['GPL-2']

  s.authors     = ['John Albin Wilkins']
  s.email       = 'virtually.johnalbin@gmail.com'

  s.add_runtime_dependency('sass',    ">= 3.3.0.rc.2")
  s.add_runtime_dependency('compass', ">= 1.0.0.alpha.5")

  s.files       = %w[
    _normalize.scss
    bower.json
    CHANGELOG.md
    component.json
    CONTRIBUTING.md
    lib/normalize-scss.rb
    LICENSE.md
    normalize-scss.gemspec
    README.md
    test.html
  ]
end
