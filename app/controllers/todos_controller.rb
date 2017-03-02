class TodosController < ApplicationController

  def index
    @todos = Todo.all
    render json: @todos
  end

  def show
    begin
      @todo = Todo.find(params[:id])
      render json: @todo
    rescue ActiveRecord::RecordNotFound => e
      puts e.message
      render json: {message: e.message}, status: :not_found
    end
  end

end
