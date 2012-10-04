POD_VERSION='v0.0.1'

Pod::Spec.new do |s|
  s.name     = 'Clutter'
  s.summary     = 'Some generally-useful support bits for iOS and OSX development.'
  s.description = 'Some generally-useful support bits for iOS and OSX development.'

  s.version  = POD_VERSION[1..-1]
  s.license  = {type:'MIT', file:'LICENSE'}
  s.homepage = 'https://github.com/sagran/Clutter'
  s.author   = {'Sergey Grankin' => 'sagran@gmail.com' }
  s.source   = {git:'https://github.com/sagran/Clutter.git', tag:POD_VERSION}


  s.source_files = 'Clutter'
  # s.header_mappings_dir = 'Clutter' # preserve the header directory layout
  s.preserve_paths = 'Specs'
  # s.resources = "icon.png"

  s.requires_arc = true

  s.prefix_header_contents = '#import "Clutter.h"'
  s.ios.frameworks = 'Foundation', 'UIKit', 'CoreData'
  s.ios.deployment_target = '5.0'
  s.osx.frameworks = 'Foundation', 'CoreData'
  # s.libraries = 'objc'

  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  # s.dependency 'JSONKit', '~> 1.4'
end

# vi:set ft=ruby:
