# frozen_string_literal: true

class AddCompletedDateToTodo < ActiveRecord::Migration[7.0]
  def change
    add_column :todos, :completedDate, :string
  end
end
