require 'fastercsv'

def legislators_import(file_name)
  csv    = FasterCSV.parse(File.open("tmp/#{file_name}").read)
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
    if legislator = (Legislator.where(:bioguide_id => attrs['bioguide_id'], :in_office => true).first rescue nil)
      yield legislator if block_given?
      unless legislator.update_attributes(attrs)
        puts "Update failed for #{attrs['bioguide_id']}"
        stats[:updated_failed] += 1
      else
        stats[:updated] += 1
      end
    else
      legislator = Legislator.new(attrs)
      legislator.bioguide_id = attrs['bioguide_id']
      yield legislator if block_given?
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

def shared_settings(legislator)
  legislator.level     = 'state'
  legislator.in_office = true
  legislator
end

namespace :legislators do
  namespace :import do
    desc 'Import federal legislators'
    task :federal do
      legislators_import('federal_legislators.csv') do |legislator|
        legislator.level = 'federal'
      end
    end

    namespace :state do
      desc 'Import MA legislators'
      task :ma do
        legislators_import('ma-Senate.csv') do |legislator|
          shared_settings(legislator)
          legislator.state = 'MA'
          legislator.title = 'Sen'
        end

        legislators_import('ma-House.csv') do |legislator|
          shared_settings(legislator)
          legislator.state = 'MA'
          legislator.title = 'Rep'
        end
      end
    end
  end
end
