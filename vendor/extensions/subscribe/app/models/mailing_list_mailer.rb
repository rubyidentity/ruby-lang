class MailingListMailer < ActionMailer::Base
  
  def subscribe_message(first_name, last_name, email, list)
    recipients list.ctl_address
    from       email
    subject    "Subscribe #{first_name} #{last_name}"
  
    part "text/plain" do |p|
      p.body = "subscribe #{first_name} #{last_name}"
    end
  end
  
  def unsubscribe_message(email, list)
    recipients email
    from       list.ctl_address
    subject    "Unsubscribe confirmation request (#{list.name.downcase} ML)"
  
    part "text/plain" do |p|
      p.body =
        "Hi,\n" +
        "\n" +
        "I've received a request to unsubscribe you from the \n" +
        "#{list.name} mailing list. To confirm this request, send a \n" +
        "message to <#{list.ctl_address}> with absolutely \n" +
        "nothing but the word `unsubscribe' in the body.\n" +
        "\n" +
        "--#{list.post_address}, Be Seeing You!"
    end
  end
  
end