POD_VERSION='v0.0.1'

module ::G
  def self.sources path
    exts = ".{h,hpp,c,cpp,cxx,m,mm}"
    includes = "#{path}/**/*#{exts}"
    excludes = "#{path}/**/*_Tests#{exts}"
    return includes, excludes
  end
end

Pod::Spec.new do |s|
  s.name     = 'Clutter'
  s.summary     = 'Some generally-useful support bits for iOS and OSX development.'
  s.description = 'Some generally-useful support bits for iOS and OSX development.'

  s.homepage = 'https://github.com/sgrankin/Clutter'
  s.author   = {'Sergey Grankin' => 'sgrankin@gmail.com' }
  s.source   = {git:'https://github.com/sgrankin/Clutter.git', tag:POD_VERSION}

  s.version  = POD_VERSION[1..-1]
  s.license  = {type:'MIT', file:'LICENSE'}

  s.requires_arc = true
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.frameworks = %w{Foundation}
  s.xcconfig = {
    'OTHER_CFLAGS' => '-std=gnu11',
    'OTHER_CPLUSPLUSFLAGS' => '-std=gnu++11 -stdlib=libc++',
  }

  s.source_files, s.exclude_files = ::G.sources 'Clutter'
  s.prefix_header_contents = '#import "Clutter.h"'
  # s.preserve_paths = 'Specs'

  s.subspec 'CoreExt' do |ss|
    frameworks = %w{CoreData CoreGraphics}
    source_files, exclude_files = ::G.sources 'Clutter/CoreExt'

    ss.ios.frameworks = frameworks + %w{CoreImage UIKit}
    ss.ios.source_files = source_files.dup
    ss.ios.exclude_files = exclude_files.dup

    ss.osx.frameworks = frameworks + %w{QuartzCore}
    ss.osx.source_files = source_files.dup #.exclude(/UIKit/) # TODO
    ss.osx.exclude_files = exclude_files.dup

    ss.dependency 'MAObjCRuntime'
  end

  s.subspec 'Error' do |ss|
    ss.source_files = ::G.sources 'Clutter/Error'
    ss.dependency 'Clutter/CoreExt'
  end

  s.subspec 'StateMachine' do |ss|
    ss.source_files = ::G.sources 'Clutter/StateMachine'
    ss.dependency 'Clutter/CoreExt'
  end

  s.subspec 'UserDefaults' do |ss|
    ss.source_files = ::G.sources 'Clutter/UserDefaults'
    ss.dependency 'Clutter/CoreExt'
  end

  # s.header_mappings_dir = 'Clutter' # preserve the header directory layout
  # s.resources = "icon.png"
end

# vi:set ft=ruby:
