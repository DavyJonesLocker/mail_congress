require 'rubygems'
require 'ruby-debug'
require 'nokogiri'
require 'open-uri'

class String
   def titleize
      non_capitalized = %w{of etc and by the for on is at to but nor or a via}
      downcase.gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }
   end
end

class MAScraper
  Suffixes = ['Jr', 'Jr.', 'Junior', 'Sr', 'Sr.', 'Senior']
  Url = 'http://www.malegislature.gov/People/'

  def self.scrape(type)
    puts "Scraping MA #{type} Members..."
    directory = Nokogiri::HTML(open(Url + type))
    member_table = directory.search('#memberDirectoryTab table')
    member_profile_links = member_table.search('a').select { |link| link.attributes["href"].value =~ /\/People\/Profile\/.+/ }
    member_count = 1
    members = member_profile_links.inject([]) do |members, link|
      member_hash = {}
      id  = "#{link.attributes["href"].value.match(/\/People\/Profile\/(.+)/)[1]}"
      member_hash['bioguide_id'] = "MA_#{id}"

      member_hash['fullname'] = link.text.strip
      puts "#{member_count} #{member_hash['fullname']}"

      parsed_name = member_hash['fullname'].scan(/([\w|'|-|-|.]+)/).flatten
      member_hash['firstname'] = parsed_name.first
      if Suffixes.include?(parsed_name.last)
        member_hash['name_suffix'] = parsed_name.last
        member_hash['lastname'] = parsed_name[-2]
        if parsed_name.size > 3
          member_hash['middlename'] = parsed_name[1]
        end
      else
        member_hash['lastname'] = parsed_name.last
        if parsed_name.size > 2
          member_hash['middlename'] = parsed_name[1]
        end
      end

      profile_page = Nokogiri::HTML(open(Url + "Profile/#{id}"))
      member_hash['image_url'] = profile_page.search('.bioPicContainer img').first.attributes["src"].value
      bio_description = profile_page.search('.bioDescription').children
      member_hash['party'] = bio_description.search('div').text.strip.split(',').first[0,1]
      member_hash['congress_office'] = bio_description.search('ul').search('li')[1].text
      member_hash['phone'] = bio_description.search('ul').search('li')[4].text.split("Phone: ")[1]
      member_hash['email'] = bio_description.search('ul').first.search('li').last.text.split("Email: ")[1]
      
      district_box = profile_page.search('#Column6 .widgetContent')
      unless district_box.empty?
        if type == 'House'
          unless district = district_box.text.strip.match(/^([\w|,|\s]+\.)/)
            district = district_box.text.strip.match(/^([\w|-]+\s\w+)/)
          end
          member_hash['district'] = district[1].gsub('.','')
        else
          member_hash['district'] = district_box.text.strip.match(/^([\w|\s|,]+)[—|.]/)[1].strip.gsub('.','').titleize
        end
      end

      member_count += 1
      members << member_hash
    end

    header = %w{id fullname firstname middlename lastname name_suffix image_url party congress_office phone email district}

    csv = members.inject([]) do |master_csv, member|
       row = header.inject([]) do |row, column|
         row << %{"#{member[column]}"}
      end.join(',')
      master_csv << row
    end.join("\n")

    file = File.new("ma-#{type}.csv", 'w+')
    file << "#{header.map { |c| %{"#{c}"} }.join(',')}\n#{csv}"
    file.close
  end
end

