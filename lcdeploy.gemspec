Gem::Specification.new do |s|
  s.name        = 'lcdeploy'
  s.version     = '0.1'
  s.executables << 'lcd'
  s.date        = '2018-08-02'
  s.summary     = 'Deploys things'
  s.description = 'Ruby is great'
  s.authors     = %w[axocomm]
  s.email       = 'axocomm@gmail.com'
  s.homepage    = 'https://github.com/axocomm/lcdeploy'
  s.files       = Dir['lib/**/*.rb']
  s.license     = 'GPL-3.0'

  s.add_dependency 'colorize', '~> 0.8'
  s.add_dependency 'net-scp', '~> 1.2'
  s.add_dependency 'net-ssh', '~> 4.2'
  s.add_dependency 'thor', '~> 0.20'
end
