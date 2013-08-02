class Message < ActiveRecord::Base
  attr_accessible :body

  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  scope :unread, -> { where(read: false) }

  # Deliver this message from sender to recipient.
  #
  # sending   - The User sending the message.
  # receiving - The User receiving the message.
  #
  # Returns the delivered Message.
  def deliver!(sending: nil, receiving: nil)
    self.sender = sending
    self.recipient = receiving
    raise "the body of the message must not be empty" if self.body.blank?
    raise ArgumentError, "both sender and recipient must be specified" unless sending && receiving
    self.save 
  end

  # Message.new(body: "Hello there!").deliver!(sending: harsh, receiving: matt)
end
