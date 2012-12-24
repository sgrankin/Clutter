require 'mini_magick'

def image_find tag
  image_base = ENV['PROJECT_NAME'] || File.basename(Dir.pwd)
  return FileList["#{image_base}-#{tag}.{png,jpeg,jpg}"].first
end

def image_resize dest, source, width, height
  img = MiniMagick::Image.open source
  img.resize "#{width}x#{height}"
  img.format 'png'
  img.write dest
end

IMAGES = {
  image_find('Icon') => [
    ['Icon.png', 57, 57],
    ['Icon@2x.png', 114, 114],
    ['Icon-72.png', 72, 72],
    ['Icon-72@2x.png', 144, 144],
    ['Icon-Small.png', 29, 29],
    ['Icon-Small@2x.png', 58, 58],
    ['Icon-Small-50.png', 50, 50],
    ['Icon-Small-50@2x.png', 100, 100],
    ['iTunesArtwork', 512, 512],
  ],
  image_find('Launch') => [
    ['Default.png', 320, 480],
    ['Default@2x.png', 640, 960],
    ['Default-568h@2x.png', 640, 1136],
  ],
  image_find('Launch~iphone') => [
    ['Default~iphone.png', 320, 480],
    ['Default@2x~iphone.png', 640, 960],
    ['Default-568h@2x~iphone.png', 640, 1136],
  ],
  image_find('Launch~ipad') => [
    ['Default~ipad.png', 768, 1004],
    ['Default@2x~ipad.png', 1536, 2008],
  ]
}

desc "Generate iOS icon & launch images from <App>-{Icon,Launch}"
task :make_images
IMAGES.each do |source, destinations|
  next unless source
  destinations.each do |destination, width, height|
    gen_file = destination + '.generated'
    # only generate files if they're not present or we generated them previously
    next unless !File.exists?(destination) or File.exists?(gen_file)

    task :make_images => [destination]
    file destination => [source] do |t|
      image_resize destination, source, width, height
      touch gen_file
    end
  end
end
