require 'rubygems'
require 'csv'
require 'open-uri'

$counter = 0
def image_pull(csv)
  image_index = csv[0].index('image_url')
  bioguide_index = csv[0].index('id')

  csv[1..-1].each do |row|
    image = open(row[image_index])
    extension = row[image_index].split('.').last
    $counter += 1
    file_name = "images/#{row[bioguide_index]}.#{extension}"
    puts "#{$counter} - #{file_name}"
    file = File.new(file_name, 'w+')
    file << image.read
    file.close
  end
end

%w{ma-House.csv ma-Senate.csv}.each do |csv_file|
  image_pull CSV.parse(File.open(csv_file).read)
end

