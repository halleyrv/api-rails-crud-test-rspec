class TodosController < ApplicationController
	before_action :set_todo, only: [:show,:update,:destroy]
	
	# GET /todos
	def index
	  @todos=Todo.all
      json_response(@todos)
	end
    
    # POST /todos
	def create
      @todo=Todo.create!(todo_params)
      json_response(@todo, 201)		
	end
    
    # POST /todos/:id
	def show
	  json_response(@todo)
	end
    
    # PUT /todos/:id
	def update
	  if @todo.update(todo_params)
	   json_response(@todo,200)
	  else
	  	json_response({errors: @todo.errors}, 422)
	  end	
	  #head :no_content	
	  
	end
    
    # DELETE /todos/:id
	def destroy
	  @todo.destroy
	  head :no_content	
	end

	private
	
	def todo_params
	  params.permit(:title,:created_by)		
	end

	def set_todo
	  @todo=Todo.find(params[:id])	
	end
end
