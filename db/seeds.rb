require 'factory_girl_rails'
require 'timecop'

letter_count = 50
puts "Seeding the database with #{letter_count} letters being sent..."
Timecop.travel 1.month.ago
advocacy_group = Factory(:advocacy_group,
  :name => 'Little Lebowski Urban Achievers',
  :email => 'test@test.com',
  :password => 'password',
  :password_confirmation => 'password',
  :contact_name => 'The Dude',
  :approved => true)

summary = <<-SUMMARY
   Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque dictum consectetur rutrum. Praesent luctus tempor cursus. Nulla sodales massa id massa gravida facilisis. Sed sollicitudin fermentum mi in blandit. Phasellus gravida lorem diam. Fusce cursus venenatis tincidunt. Sed molestie ipsum ac risus ornare aliquet. Morbi posuere lectus non magna fermentum congue egestas justo cursus. Curabitur ut diam non quam viverra congue vel vitae tortor. In mollis, ipsum vel dapibus cursus, risus erat aliquam nisl, ut posuere nulla lorem viverra sem. Suspendisse pulvinar ipsum ac augue sollicitudin non vehicula leo scelerisque. Quisque sodales posuere diam, sit amet elementum orci tristique aliquet. Nunc faucibus lacinia malesuada. Sed tempus aliquet nibh non tincidunt.
SUMMARY

body = <<-BODY
   Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras suscipit enim scelerisque magna varius sit amet malesuada risus commodo. Nullam non elementum enim. Cras vulputate vestibulum quam vitae hendrerit. Morbi suscipit felis vel mi iaculis scelerisque. Morbi ac metus lorem, eu posuere leo. Maecenas hendrerit arcu vitae metus lobortis fermentum. Fusce neque elit, lobortis eget consectetur quis, gravida vitae neque. Nam cursus, lectus quis pharetra blandit, tellus libero dignissim nisi, vel fringilla mauris odio vitae orci. Maecenas lacinia fringilla urna, eu ornare felis porta aliquet. Integer quis quam nisl.

   Quisque laoreet leo vel augue sollicitudin ut sollicitudin erat pharetra. Sed tristique tempor erat, vel posuere neque dictum non. Vestibulum magna tellus, tincidunt consectetur lobortis sed, faucibus quis ligula. Praesent molestie suscipit mollis. Nullam a magna interdum risus commodo rutrum quis quis sem. Cras eros ligula, pharetra placerat tempor nec, ullamcorper at nulla. Fusce ullamcorper orci a nisi bibendum sodales volutpat magna fermentum. Cras lectus quam, ultrices at volutpat non, dictum ut risus. Praesent nec purus sit amet eros egestas gravida. Morbi sollicitudin auctor laoreet. Sed imperdiet massa in tellus vehicula placerat.

   Praesent urna libero, ultrices et tempus ut, tristique in lacus. Nullam arcu nunc, tempus at consectetur in, posuere a justo. Sed quis nisl ligula, vel auctor mauris. Curabitur pellentesque tristique arcu ac aliquet. Nam fringilla enim suscipit lorem tincidunt vel iaculis orci tempus. Pellentesque varius gravida nulla et posuere. In dolor lacus, tempor id suscipit sed, feugiat vel nibh. Nunc hendrerit feugiat metus vel egestas. Aliquam semper, felis eget accumsan feugiat, velit risus bibendum lectus, eu semper dui dui id mauris. Suspendisse congue mollis iaculis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent varius metus a turpis porttitor commodo luctus ligula blandit. Donec at eleifend neque. Nam vel dolor eu nibh porta aliquam. Aenean at tortor at ante pulvinar consectetur. Donec in arcu quis sapien tempus porta ut vel urna. Curabitur gravida, magna a blandit posuere, erat leo pulvinar lorem, vitae ornare lacus metus eu nisl. Sed sit amet massa id enim aliquam ultricies sit amet quis risus. Quisque sed nulla dapibus nunc tempor malesuada. Aliquam eget urna nec sem consequat tincidunt.
BODY

campaign = Factory(:campaign,
  :advocacy_group => advocacy_group,
  :body => body,
  :summary => summary,
  :title => 'Support our little achievers!')

bioguide_ids = Legislator.select('bioguide_id').where(:in_office => true).map { |l| l.bioguide_id }

(1..letter_count).each do |i|
  Timecop.travel i.hour.from_now
  if rand(10) > 8
    campaign_id = nil
  else
    campaign_id = campaign.id
  end

  recipient_number = rand(3) + 1
  recipients = []
  recipient_number.times do
    recipients << Recipient.new(:legislator => Legislator.find(Legislator.find(bioguide_ids[rand(bioguide_ids.size)])))
  end

  Factory(:letter,
    :body => body,
    :campaign_id => campaign_id,
    :sender => Factory(:sender),
    :recipients => recipients,
    :follow_up_made => rand(10) > 6 ? true : false)
end

puts 'Seeding complete!'
