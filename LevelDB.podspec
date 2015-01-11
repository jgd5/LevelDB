Pod::Spec.new do |s|
  s.name         = "LevelDB"
  s.version      = "0.0.1"
  s.summary      = "An Objective-C/Swift bindings for LevelDB."
  s.homepage     = "https://github.com/jgd5/LevelDB"
  s.license      = "MIT"
  s.author       = "jgd5"
  s.source       = { :git => "https://github.com/jgd5/LevelDB.git", :commit => "982f03bce96cc8417ddac82d5408f05250d376eb" }
  s.source_files  = "LevelDB", "include/leveldb"
  s.resource = "Library/libleveldb.a"
  s.preserve_paths = "Library/"
end
