Then /the (\w?) has (\w?) queued/ do |thing, method|
  thing_obj = instance_variable_get("@#{thing}")
  thing_obj.class.should have_queued(thing_obj.id, method.to_sym)
end
