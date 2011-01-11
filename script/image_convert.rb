require 'rubygems'
require 'rmagick'

puts 'Starting conversion...'
i = 0
Dir['*.jpg'].each do |filename|
  images = Magick::ImageList.new(filename)
  images << images[0].quantize(256, Magick::GRAYColorspace)
  images.append(false).write(filename)
  i++
end

puts "Converted #{i} images!"

