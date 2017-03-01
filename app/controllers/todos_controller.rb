class TodosController < ApplicationController

  def index
    @todos = Todo.all
    render json: @todos, status: :ok
  end
end
