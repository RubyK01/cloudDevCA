# https://www.youtube.com/watch?v=c1I0faAu-6k
# https://akladyous.medium.com/ruby-on-rails-action-mailer-configuration-6d0cfc00b871
class TodoMailer < ApplicationMailer
    default from: "rubykehoe4@gmail.com"
    def completion_email(todo)
      @todo = todo
      mail(to: 'rubykehoe4@gmail.com', 
      subject: "Todo Completed: #{todo.title}",
      content_type: "text/html",
      body: "Todo: #{todo.title} \n
      was completed at #{todo.completedDate}. \n
      Kind Regards,
      Admin."
    )
    end
  end
  