require "test_helper"

class CreateTodoWorkFlowTest < ActionDispatch::IntegrationTest
    test "should try to create a new todo that is completed" do
        get "/todos/new"
        assert_response :success

        post "/todos", params: {todo: {title: "Paint the house", completed: true}}
        assert_response :found

        puts(response.parsed_body)

        assert_select 'a', "redirected"

        get "/todos"
        assert_response :success
        puts(response.parsed_body)
        assert_select "div div", 3
        assert_select "div div p", "Title:\n Paint the house"
    end
end