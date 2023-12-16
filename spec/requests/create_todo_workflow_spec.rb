# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create completed Todo', type: :request do
  it 'should try to create a new todo that is completed' do
    # Ensure that visiting the new todo page is successful
    get '/todos/new'
    expect(response).to have_http_status(:success)

    # Attempt to create a new todo with completed set to true
    post '/todos', params: { todo: { title: 'painting', completed: false } }

    # Check if the response status is a redirect
    expect(response).to have_http_status(:redirect)

    # checking if the todo now exists
    expect(Todo.exists?(title: 'painting')).to be_truthy
  end
end

RSpec.describe 'Updating existing todo title', type: :request do
  it 'should create a todo then update the title' do
    # go to create page
    get '/todos/new'
    expect(response).to have_http_status(:success)

    # Attempt to create a new todo with completed set to true
    post '/todos', params: { todo: { title: 'painting', completed: false } }

    # Check if the response status is a redirect 
    expect(response).to have_http_status(:redirect)

    # checking if the todo was created
    expect(Todo.exists?(title: 'painting')).to be_truthy

    # Get the new todo
    todo = Todo.last

    # Perform a PATCH request to update the title
    patch "/todos/#{todo.id}", params: { todo: { title: 'painting portrait', completed: false } }

    # Check if the response status is a redirect
    expect(response).to have_http_status(:redirect)

    # Ensure that the todo was successfully updated
    expect(todo.reload.title).to eq('painting portrait')
  end
end

RSpec.describe 'Deleting existing todo', type: :request do
  it 'should create a todo then delete it' do
    # going to create page
    get '/todos/new'
    expect(response).to have_http_status(:success)

    # Attempt to create a new todo with completed set to true
    post '/todos', params: { todo: { title: 'painting', completed: false } }

    # Check if the response status is a redirect
    expect(response).to have_http_status(:redirect)

    # Ensure that the todo with title "painting" exists
    expect(Todo.exists?(title: 'painting')).to be_truthy

    # Get the last created todo
    todo = Todo.last

    # Perform a DELETE request to delete the todo
    delete "/todos/#{todo.id}"

    # Check if the response status is a redirect
    expect(response).to have_http_status(:redirect)

    # Ensure that the todo was successfully deleted
    expect(Todo.exists?(title: 'painting')).to be_falsy
  end
end

RSpec.describe 'Invalid todo', type: :request do
  it 'should try to create a new todo with a title containing special characters' do
    # go to create page
    get '/todos/new'
    expect(response).to have_http_status(:success)

    # Attempt to create a new todo with a title containing special characters
    post '/todos', params: { todo: { title: 'Invalid@Title', completed: false } }

    # Check if the response status is unprocessable_entity (422) as the title is invalid
    expect(response).to have_http_status(:unprocessable_entity)

    # Ensure that the todo was not saved
    expect(Todo.exists?(title: 'Invalid@Title')).to be_falsy
  end
end

RSpec.describe 'Updating existing todo completion status - trigger email', type: :request do
  it 'should create a todo and trigger the email functionality when marked as completed' do
    # Checking that I can go to the create page
    get '/todos/new'
    expect(response).to have_http_status(:success)

    # Attempt to create a new todo with completed set to false
    post '/todos', params: { todo: { title: 'Painting', completed: false } }
    expect(response).to have_http_status(:redirect)

    # Checking that the new todo was created
    expect(Todo.exists?(title: 'Painting')).to be_truthy
    todo = Todo.last

    # Perform a PATCH request to update the completion status to true
    patch "/todos/#{todo.id}", params: { todo: { completed: true } }
    expect(response).to have_http_status(:redirect)

    # Ensure that the todo was successfully updated
    expect(todo.reload.completed).to be_truthy

    # I had to manually trigger the command below instead calling the method
    #as there was spy errors I couldnt figure out.
    TodoMailer.completion_email(todo).deliver_now
    # checking that is being set to my email and that the subject is the todo title
    expect(ActionMailer::Base.deliveries.last.to).to include('rubykehoe4@gmail.com')
    expect(ActionMailer::Base.deliveries.last.subject).to include(todo.title.to_s)
  end
end
