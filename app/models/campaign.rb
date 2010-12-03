class Campaign < ActiveRecord::Base
  self.inheritance_column = 'other_type'
  has_many   :letters
  belongs_to :advocacy_group

  validates_presence_of :title
  validates_presence_of :summary
  validates_presence_of :body

  def activity_days
    first_created_letter = letters.order('created_at ASC').limit(1).first
    last_updated_letter  = letters.order('updated_at DESC').limit(1).first
    date_range = Date.parse(first_created_letter.created_at.to_s)..Date.parse(last_updated_letter.updated_at.to_s)
    date_range.map { |date| date.strftime('%b %d') }
  end

  def letters_sent
    sql = <<-SQL
select date(date_trunc('day', letters.created_at)) as "Day", count(recipients.id)
from letters
join recipients on (recipients.letter_id = letters.id)
where letters.campaign_id = #{self.id}
group by "Day"
order by "Day"
    SQL
    collect_data(sql)
  end

  def follow_ups_made
    sql = <<-SQL
select date(date_trunc('day', letters.updated_at)) as "Day", count(recipients.id)
from letters
join recipients on (recipients.letter_id = letters.id)
where letters.campaign_id = #{self.id} and letters.follow_up_made is true
group by "Day"
order by "Day"
    SQL
    collect_data(sql)
  end

  private

  def collect_data(sql)
    records = ActiveRecord::Base.connection.execute(sql).inject({}) do |collection, result|
      collection.merge!(Date.parse(result['Day']).strftime('%b %d') => result['count'])
    end
    activity_days.map do |day|
      if records[day]
        records[day].to_i
      else
        0
      end
    end
  end

end
