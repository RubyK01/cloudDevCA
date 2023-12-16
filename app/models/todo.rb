require 'singleton'
# references
# https://apidock.com/rails/v4.0.2/ActiveRecord/FinderMethods/find_by
# https://guides.rubyonrails.org/active_record_callbacks.html
# https://www.rubyguides.com/2020/04/self-in-ruby/
# https://www.youtube.com/watch?v=c1I0faAu-6k
# https://ruby-doc.org/stdlib-2.6.3/libdoc/logger/rdoc/Logger.html
# https://stackoverflow.com/questions/24041379/validate-so-that-no-special-characters-are-allowed
class Todo < ApplicationRecord
  # checking if title has a value before being submitted.
  validates :title, presence: true

  # Custom validation: Check that the title does not contain special characters
  validate :title_does_not_contain_special_characters

  # Trigger the send_completion_notification method after committing if completed was set to true
  after_commit :send_completion_notification, if: :completed_changed?

  # Custom validation method to check if the title contains special characters
  def title_does_not_contain_special_characters
    # Regular expression /^[a-zA-Z0-9\s]+$/ checks if the title contains only letters (both uppercase and lowercase), numbers, and whitespace
    return if title =~ /^[a-zA-Z0-9\s]+$/

    # If the title contains special characters, add an error to the :title variable
    errors.add(:title, 'cannot contain special characters')
  end

  # previous attempt trying to find the last updated todo in db instead of just using the current instance
  # def send_completion_notification
  #   get_completed_todo = Todo.find_by("updated_at >= ?", Date.today)
  #   TodoMailer.completion_email(get_completed_todo).deliver_now
  def send_completion_notification # email function 
    # I pass the current todo instance through the completion_email method in the TodoMailer class
    # upon a todos completed variable being set to true in an update operation 
    # and an send the email straight away
    # The 
    TodoMailer.completion_email(self).deliver_now if completed
  rescue StandardError => e
    Rails.logger.error("Error sending completion email: #{e.message}")
  end

  public :send_completion_notification
end
