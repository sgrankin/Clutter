Pod::Spec.new do |s|
  s.name     = 'Clutter'
  s.version  = '0.0.1'
  s.license  = {type:'MIT', file:'LICENSE'}
  s.summary  = 'Miscelaneous iOS/Mac classes and additions.'
  s.homepage = 'http://www.thunderbunny.net/gitweb/Clutter.git'
  s.author   = {'Sergey Grankin' => 'sagran@gmail.com' }
  s.source   = {git:'git:surge/clutter.git', commit:'HEAD'}
  s.description = 'An unsorted assortment useful classes and additions.'

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
