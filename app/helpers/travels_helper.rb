module TravelsHelper
  def mail_to_recipients(recipients)
    recipients.split(",").collect!{ |recipient| mail_to recipient }.to_sentence
  end
end
