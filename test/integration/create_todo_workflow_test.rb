require "test_helper"

class CreateTodoWorkFlowTest < ActionDispatch::IntegrationTest
  test "should try to create a new todo that is completed" do
    # Ensure that visiting the new todo page is successful
    get "/todos/new"
    assert_response :success

    # Attempt to create a new todo with completed set to true
    post "/todos", params: { todo: { title: "Paint the house", completed: true } }
    
    # Check if the response status is 200 OK
    assert_response :ok

    # No need for assert_select if you're not checking HTML content

    # You can add additional assertions as needed
  end
end


