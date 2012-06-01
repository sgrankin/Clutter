Pod::Spec.new do |s|
  s.name     = 'Clutter'
  s.version  = '0.0.0'
  # s.license  = 'MIT'
  s.summary  = 'Miscelaneous iOS classes and additions.'
  s.homepage = 'http://www.thunderbunny.net/gitweb/Clutter.git'
  s.author   = { 'Sergey Grankin' => 'sagran@gmail.com' }
  s.source   = { :git => 'http://git/Clutter.git' }
  #s.description  = 'Miscelaneous iOS classes and additions.'

  s.platform = :ios
  s.source_files = 'Clutter'
  # s.resources = "icon.png"
  s.clean_paths = 'ClutterTests', '*.xcodeproj', 'Podfile*'

  s.frameworks = 'Foundation', 'UIKit'
  # s.libraries = 'iconv'
  s.requires_arc = true

  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  # s.dependency 'JSONKit', '~> 1.4'
end
# vi:set ft=ruby:
