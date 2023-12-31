# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy]
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  # GET /todos or /todos.json
  def index
    @todos = Todo.all
  end

  # GET /todos/1 or /todos/1.json
  def show; end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit; end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)
    #set the start date to todays date in yyyy/mm/dd format
    @todo.startDate = Date.today.to_s
    respond_to do |format|
      if @todo.save
        format.html { redirect_to todo_url(@todo), notice: 'Todo was successfully created!' }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)

        if @todo.completed
          # if completed is set to true in an update operation
          # the completedDate variable is given a string of todays date in yyyy/mm/dd format
          @todo.completedDate = Date.today.to_s
          @todo.save
        end

        # I call the send completion notification method in this instance
        # to see if the completed field is set to true in order for an email to be sent.
        @todo.send_completion_notification

        format.html { redirect_to todo_url(@todo), notice: 'Todo was successfully updated!' }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to todos_url, notice: 'Todo was successfully deleted!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = Todo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def todo_params
    params.require(:todo).permit(:title, :completed)
  end
end
