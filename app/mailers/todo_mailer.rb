# frozen_string_literal: true

# https://www.youtube.com/watch?v=c1I0faAu-6k
# https://akladyous.medium.com/ruby-on-rails-action-mailer-configuration-6d0cfc00b871
class TodoMailer < ApplicationMailer
  default from: 'rubykehoe4@gmail.com' #sender address in this case my email
  def completion_email(todo) # I take a todo as a paramator
    @todo = todo # putting the instance in a variable
    mail(to: 'rubykehoe4@gmail.com', # recipiant of the email, change it to your email if you want to recieve it
         subject: "Todo Completed: #{todo.title}", # set the email subject to the title of the todo
         content_type: 'text/html', # telling the content-type header what will be in the email
         body: "Todo: #{todo.title} \n
      was completed at #{todo.completedDate}. \n
      Kind Regards,
      Admin.")
  end
end
