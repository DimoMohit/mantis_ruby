Gem::Specification.new do |s|
  s.name        = 'mantis_ruby'
  s.version     = '0.1.2'
  s.date        = '2016-06-05'
  s.summary     = "Mantis Testing tool with Ruby"
  s.description = "Gem to integrate Mantis Testing tool with Ruby apps"
  s.authors     = ["Dimo Mohit"]
  s.email       = 'mohitdutta@live.com'
  s.files       = ["lib/mantis_ruby.rb"]
  s.homepage    =
    'https://github.com/DimoMohit/mantis_ruby'
  s.license       = 'MIT'
  s.add_dependency("ruby", ">= 1.9")
  s.add_dependency("savon")
  s.add_dependency("httpclient")
end