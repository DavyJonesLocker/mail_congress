require 'fastercsv'

def legislators_import
  csv    = FasterCSV.parse(File.open('tmp/legislators.csv').read)
  header = csv[0]
  stats = {
    :updated => 0,
    :updated_failed => 0,
    :created => 0,
    :created_failed => 0
  }
  csv[1..-1].each do |row|
    attrs = {}
    row.each_with_index do |attr, index|
      attrs[header[index]] = attr
    end
    if legislator = (Legislator.find(attrs['bioguide_id']) rescue nil)
      unless legislator.update_attributes(attrs)
        puts "Update failed for #{attrs['bioguide_id']}"
        stats[:updated_failed] += 1
      else
        stats[:updated] += 1
      end
    else
      legislator = Legislator.new(attrs)
      legislator.bioguide_id = attrs['bioguide_id']
      unless legislator.save
        stats[:created_failed] += 1
        puts "Creation failed for #{attrs['bioguide_id']}"
      else
        stats[:created] += 1
      end
    end
  end

  puts "Stats:"
  puts "Updated: #{stats[:updated]}"
  puts "Updated failed: #{stats[:updated_failed]}"
  puts "Created: #{stats[:created]}"
  puts "Created failed: #{stats[:created_failed]}"
  puts "Total: #{stats.inject(0) { |total, stat| total += stat[1] }}"
end

namespace :legislators do
  desc 'Legislators import from tmp/legislators.csv'
  task :import do
    legislators_import
  end
end
