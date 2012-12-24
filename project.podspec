POD_VERSION='v0.0.1'

module ::G
  def self.sources path
    exts = ".{h,hpp,c,cpp,cxx,m,mm}"
    return FileList["#{path}/*#{exts}"].exclude(/_Tests\./)
  end
end

Pod::Spec.new do |s|
  s.name     = 'TODO'
  s.summary     = 'TODO'
  s.description = 'TODO'

  s.homepage = 'https://github.com/TODO/TODO'
  s.author   = {'TODO' => 'TODO' }
  s.source   = {git:'TODO', tag:POD_VERSION}

  s.version  = POD_VERSION[1..-1]
  s.license  = {type:'MIT', file:'LICENSE'}

  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.frameworks = %w{Foundation}
  s.xcconfig = {
    'OTHER_CFLAGS' => '-std=gnu11',
    'OTHER_CPLUSPLUSFLAGS' => '-std=gnu++11 -stdlib=libc++',
  }

  s.source_files = ::G.sources 'Project'
  s.prefix_header_contents = '#import "Project.h"'
  # s.preserve_paths = 'Specs'

  s.subspec 'CoreExt' do |ss|
    frameworks = %w{CoreData CoreGraphics}
    source_files = ::G.sources 'Clutter/CoreExt/**'

    ss.ios.frameworks = frameworks + %w{CoreImage UIKit}
    ss.ios.source_files = source_files.dup

    ss.osx.frameworks = frameworks + %w{QuartzCore}
    ss.osx.source_files = source_files.dup.exclude(/UIKit/)

    ss.dependency 'MAObjCRuntime'
  end
end
