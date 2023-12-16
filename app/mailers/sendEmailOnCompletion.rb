# frozen_string_literal: true

# https://guides.rubyonrails.org/active_record_callbacks.html
class SendEmailOnCompletion
  def send_completion_email(todo)
    # Your email sending logic here
    puts "Sending completion email for todo: #{todo.title}"
  end
end
