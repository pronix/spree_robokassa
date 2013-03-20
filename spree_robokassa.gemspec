Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_robokassa'
  s.version     = '0.50.2'
  s.summary     = 'Adds payment method for robokassa.ru'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  s.authors           = ['Roman Smirnov', 'parallel588']
  # s.email             = 'david@loudthinking.com'
  s.homepage          = 'https://github.com/romul/spree_robokassa'
  # s.rubyforge_project = 'spree_robokassa'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = [ 'lib' ]
  s.requirements << 'none'

  s.add_dependency('spree_core', '>= 0.40.0')
end
