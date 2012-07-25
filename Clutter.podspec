Pod::Spec.new do |s|
  s.name     = 'Clutter'
  s.version  = '0.0.1'
  s.license  = {type:'MIT', file:'LICENSE'}
  s.summary  = 'Miscelaneous iOS classes and additions.'
  s.homepage = 'http://www.thunderbunny.net/gitweb/Clutter.git'
  s.author   = {'Sergey Grankin' => 'sagran@gmail.com' }
  s.source   = {git:'git:clutter.git', commit:'HEAD'}
  s.description = 'An unsorted assortment of iOS classes and additions.'

  s.platform = :ios
  s.source_files = 'Clutter/**/*.{h,m,mm,c,cpp}'
  # s.header_mappings_dir = 'Clutter' # preserve the header directory layout
  # s.resources = "icon.png"
  # s.preserve_paths = 'moreinfo.txt'

  s.prefix_header_contents = '#import "Clutter.h"'
  s.frameworks = 'Foundation', 'UIKit', 'CoreData'
  # s.libraries = 'objc'
  s.requires_arc = true

  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  # s.dependency 'JSONKit', '~> 1.4'
end

# vi:set ft=ruby:
