require 'singleton'
require 'sendEmailOnCompletion'
#https://apidock.com/rails/v4.0.2/ActiveRecord/FinderMethods/find_by
#https://guides.rubyonrails.org/active_record_callbacks.html
#https://www.rubyguides.com/2020/04/self-in-ruby/
class Todo < ApplicationRecord
    after_commit :send_completion_notification, if: :completed_changed?
    

    # previous attempt trying to get find the last updated todo
    # def send_completion_notification
    #   # Use self to refer to the current instance of Todo
    #   get_completed_todo = Todo.find_by("updated_at >= ?", Date.today)
    #   TodoMailer.completion_email(get_completed_todo).deliver_now
    def send_completion_notification
        if self.completed
            TodoMailer.completion_email(self).deliver_now
        end
    rescue => e
      Rails.logger.error("Error sending completion email: #{e.message}")
    end
  
    public :send_completion_notification
  end
  
  