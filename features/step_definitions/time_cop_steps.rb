When '$time pass' do |time|
  Timecop.travel Chronic.parse("#{time} from now")
end

