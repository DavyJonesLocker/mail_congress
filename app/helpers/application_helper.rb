module ApplicationHelper

  def cost_to_send_letters(recipients)
    selected_count = recipients.inject(0) { |count, recipient| count += 1 if recipient.selected?; count }
    case selected_count
    when 0
     'Please choose to whom you wish to write'
    when 1
     '$1 to send this letter'
    else
      "$#{selected_count} to send these letters"
    end
  end
end
