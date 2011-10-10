module TravelsHelper
  def mail_to_recipients(recipients)
    recipients = recipients.split(",")
    recipients.collect!{ |recipient| mail_to recipient }
    [recipients.delete_at(-1), recipients.join(", ")].reverse.join(" e ")
  end
end
