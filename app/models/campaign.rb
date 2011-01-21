class Campaign < ActiveRecord::Base
  self.inheritance_column = 'other_type'
  has_many   :letters
  belongs_to :advocacy_group

  validates_presence_of :title
  validates_presence_of :summary
  validates_presence_of :body
  validate :validate_level_and_type

  def activity_days
    if letters.count == 0
      []
    else
      first_created_letter = letters.order('created_at ASC').limit(1).first
      last_updated_letter  = letters.order('updated_at DESC').limit(1).first
      date_range = Date.parse(first_created_letter.created_at.to_s)..Date.parse(last_updated_letter.updated_at.to_s)
      date_range.map { |date| date.strftime('%b %d') }
    end
  end

  def letters_sent
    if letters.count == 0
      []
    else
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
  end

  def follow_ups_made
    if letters.count == 0
      []
    else
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
  end

  def level_and_type
    [:level, :type].inject({}) do |hash, attr|
      if read_attribute(attr) != 'all'
        hash.merge!(attr => read_attribute(attr))
      else
        hash
      end
    end
  end

  private

  def validate_level_and_type
    if type != 'all' && level == 'all'
      errors.add(:level, 'A level must be chosen before chosing a type')
    end
  end

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
