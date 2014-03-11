Pod::Spec.new do |s|
  s.name     = 'FCTextFilterer'
  s.version  = '0.1.0'
  s.platform = :ios
  s.license  = 'MIT' 
  s.summary  = 'Text filterer for iOS'
  s.homepage = 'https://github.com/arkorwan/FCTextFilterer'
  s.author   = { 'Worakarn Isaratham' => 'arkorwan@gmail.com' }
  s.source   = { :git => 'https://github.com/arkorwan/FCTextFilterer.git', :tag => 'v0.1.0' }
  s.description = 'Text filterer for iOS.'
  s.source_files = 'FCTextFilterer/*.{h,m}'
  s.requires_arc = true
end
