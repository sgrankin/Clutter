require 'mini_magick'

namespace :build do
  if ENV['SOURCE_ROOT'] # some tasks can only be done as part of a build in Xcode
    SOURCE_ROOT = Pathname.new(ENV['SOURCE_ROOT'])
    TARGET_ROOT = Pathname.new(ENV['TARGET_BUILD_DIR']) + ENV['UNLOCALIZED_RESOURCES_FOLDER_PATH']

    def find_image image
      return FileList[(SOURCE_ROOT + %{#{ENV['EXECUTABLE_NAME']}-#{image}.{png,jpeg,jpg}}).to_s].first
    end

    ICON_IMAGE = find_image 'Icon'
    LAUNCH_IMAGE = find_image 'Launch'
    LAUNCH_IPHONE_IMAGE = find_image 'Launch~iphone'
    LAUNCH_IPAD_IMAGE = find_image 'Launch~ipad'

    desc "Create iOS icons and artwork"
    task :artwork

    def artwork_task source, image, w, h
      image = TARGET_ROOT + image
      file image => [source] do |t|
        img = MiniMagick::Image.open t.prerequisites.first
        img.resize "#{w}x#{h}"
        img.format 'png'
        img.write t.name
      end
      task :artwork => [image]
    end

    if ICON_IMAGE
      artwork_task ICON_IMAGE, 'Icon.png', 57, 57
      artwork_task ICON_IMAGE, 'Icon@2x.png', 114, 114
      artwork_task ICON_IMAGE, 'Icon-72.png', 72, 72
      artwork_task ICON_IMAGE, 'Icon-72@2x.png', 144, 144
      artwork_task ICON_IMAGE, 'Icon-Small-.png', 29, 29
      artwork_task ICON_IMAGE, 'Icon-Small-@2x.png', 58, 58
      artwork_task ICON_IMAGE, 'Icon-Small-50.png', 50, 50
      artwork_task ICON_IMAGE, 'Icon-Small-50@2x.png', 100, 100
      artwork_task ICON_IMAGE, 'iTunesArtwork', 512, 512
    end

    if LAUNCH_IMAGE
      artwork_task LAUNCH_IMAGE, 'Default.png', 320, 480
      artwork_task LAUNCH_IMAGE, 'Default@2x.png', 640, 960
    end

    if LAUNCH_IPHONE_IMAGE
      artwork_task LAUNCH_IPHONE_IMAGE, 'Default~iphone.png', 320, 480
      artwork_task LAUNCH_IPHONE_IMAGE, 'Default@2x~iphone.png', 640, 960
    end

    if LAUNCH_IPAD_IMAGE
      artwork_task LAUNCH_IPAD_IMAGE, 'Default~ipad.png', 768, 1004
      artwork_task LAUNCH_IPAD_IMAGE, 'Default@2x~ipad.png', 1536, 2008
    end
  end
end

desc 'Execute all Xcode build-time tasks'
task :build => ['build:artwork']
