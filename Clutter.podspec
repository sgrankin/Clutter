POD_VERSION='v0.0.1'
FILE_GLOB='*.{h,hpp,c,cpp,cxx,m,mm}'

Pod::Spec.new do |s|
  s.name     = 'Clutter'
  s.summary     = 'Some generally-useful support bits for iOS and OSX development.'
  s.description = 'Some generally-useful support bits for iOS and OSX development.'

  s.homepage = 'https://github.com/sagran/Clutter'
  s.author   = {'Sergey Grankin' => 'sagran@gmail.com' }
  s.source   = {git:'https://github.com/sagran/Clutter.git', tag:POD_VERSION}

  s.version  = POD_VERSION[1..-1]
  s.license  = {type:'MIT', file:'LICENSE'}

  s.requires_arc = true
  s.ios.deployment_target = '5.0'

  s.frameworks = 'Foundation'
  s.libraries = 'c++'
  s.xcconfig = {
    'GCC_C_LANGUAGE_STANDARD' => 'gnu99',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++0x',
  }

  s.source_files = "Clutter/#{FILE_GLOB}"
  s.prefix_header_contents = '#import "Clutter.h"'
  s.preserve_paths = 'Specs'

  s.subspec 'Core' do |ss|
    ss.source_files = "Clutter/Core/*#{FILE_GLOB}"
  end

  s.subspec 'CoreData' do |ss|
    ss.source_files = "Clutter/CoreData/#{FILE_GLOB}"
    ss.frameworks = 'CoreData'
  end

  s.subspec 'CoreImage' do |ss|
    ss.source_files = "Clutter/CoreImage/#{FILE_GLOB}"
    ss.frameworks = 'CoreGraphics'
    ss.osx.frameworks = 'QuartzCore'
    ss.ios.frameworks = 'CoreImage'
  end

  s.subspec 'Foundation' do |ss|
    ss.source_files = "Clutter/Foundation/#{FILE_GLOB}"
  end

  s.subspec 'UIKit' do |ss|
    ss.source_files = "Clutter/UIKit/#{FILE_GLOB}"
    ss.platform = :ios
    ss.ios.frameworks = 'UIKit'
  end

  # s.header_mappings_dir = 'Clutter' # preserve the header directory layout
  # s.resources = "icon.png"
end

# vi:set ft=ruby:
