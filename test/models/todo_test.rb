# frozen_string_literal: true

require 'test_helper'
# https://guides.rubyonrails.org/testing.html
class TodoTest < ActiveSupport::TestCase
  # Test case to check if a Todo with a valid title can be saved
  test 'should save todo with valid title' do
    todo = Todo.new(title: 'Valid Title', completed: false)
    assert todo.save
  end

  # Test case to check if a Todo without a title cannot be saved
  test 'should not save todo without title' do
    todo = Todo.new(completed: false)
    assert_not todo.save
  end

  # Test case to check if a Todo with a title containing special characters cannot be saved
  test 'should not save todo with title containing special characters' do
    todo = Todo.new(title: 'Invalid@Title', completed: false)
    assert_not todo.save
  end

  # Test case to check if send_completion_notification is called after committing changes when 'completed' is changed to true
  test 'should call send_completion_notification after committing changes if completed changed' do
    todo = todos(:one) # replace with the actual fixture or instance
    allow(todo).to receive(:send_completion_notification)

    # Make changes that trigger send_completion_notification
    todo.update(completed: true)

    # Assert that send_completion_notification was called
    assert_received(todo, :send_completion_notification)
  end

  # Test case to check if send_completion_notification is not called after committing changes when 'completed' is not changed
  test 'should not call send_completion_notification after committing changes if completed not changed' do
    todo = todos(:one) # replace with the actual fixture or instance
    allow(todo).to receive(:send_completion_notification)

    # Make changes that won't trigger send_completion_notification
    todo.update(title: 'New Title')

    # Assert that send_completion_notification was not called
    assert_not_received(todo, :send_completion_notification)
  end
end
