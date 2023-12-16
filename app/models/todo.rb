# frozen_string_literal: true

require 'singleton'
require 'sendEmailOnCompletion'
# https://apidock.com/rails/v4.0.2/ActiveRecord/FinderMethods/find_by
# https://guides.rubyonrails.org/active_record_callbacks.html
# https://www.rubyguides.com/2020/04/self-in-ruby/
class Todo < ApplicationRecord
  # Validation: Ensure the presence of the title attribute
  validates :title, presence: true

  # Custom validation: Check that the title does not contain special characters
  validate :title_does_not_contain_special_characters

  # Callback: Trigger the send_completion_notification method after committing changes if the 'completed' attribute changed
  after_commit :send_completion_notification, if: :completed_changed?

  # Custom validation method to check if the title contains special characters
  def title_does_not_contain_special_characters
    # Regular expression /^[a-zA-Z0-9\s]+$/ checks if the title contains only letters (both uppercase and lowercase), numbers, and whitespace
    return if title =~ /^[a-zA-Z0-9\s]+$/

    # If the title contains special characters, add an error to the :title attribute
    errors.add(:title, 'cannot contain special characters')
  end

  # previous attempt trying to find the last updated todo in db instead of just using the current instance
  # def send_completion_notification
  #   get_completed_todo = Todo.find_by("updated_at >= ?", Date.today)
  #   TodoMailer.completion_email(get_completed_todo).deliver_now
  def send_completion_notification
    TodoMailer.completion_email(self).deliver_now if completed
  rescue StandardError => e
    Rails.logger.error("Error sending completion email: #{e.message}")
  end

  public :send_completion_notification
end
