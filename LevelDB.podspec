Pod::Spec.new do |s|
  s.name = 'LevelDB'
  s.version = '0.1'
  s.license = 'MIT'
  s.summary = 'An Objective-C/Swift bindings for LevelDB.'
  s.homepage = 'https://github.com/jgd5/LevelDB'
  s.source = { :git => 'https://github.com/jgd5/LevelDB.git' }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'LevelDB/*'
end
