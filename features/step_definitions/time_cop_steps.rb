When /(\d+) days pass/ do |days|
  Timecop.travel days.to_i.business_days.from_now
end

