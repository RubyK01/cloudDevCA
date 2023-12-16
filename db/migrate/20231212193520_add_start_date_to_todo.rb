# frozen_string_literal: true

class AddStartDateToTodo < ActiveRecord::Migration[7.0]
  def change
    add_column :todos, :startDate, :string
  end
end
