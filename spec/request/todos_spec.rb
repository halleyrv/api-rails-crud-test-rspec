require 'rails_helper'

RSpec.describe 'Todos Api', type: :request do
  # initialize data
  let!(:todos) { create_list(:todo , 10) }
  let(:todo_id){todos.first.id}
    
  # Test suite for - GET all records 
  describe "GET /todos" do
    
    before { get '/todos' }
      
      it 'return todos ' do
      	expect(json).not_to be_empty
      	expect(json.size).to eq(10)
      end
	  
	  it 'return status code 200' do
	  	expect(response).to have_http_status(200)
	  end	
  end
    
  # Test suit for GET /todos/:id -SHOW A ONE RECORD
  describe "GET /todos/:id" do
    
    before { get "/todos/#{todo_id}" }
    
    context 'when the record exists' do
	  
	  it 'returns todo' do
	  	expect(json).not_to be_empty
	  	expect(json['id']).to eq(todo_id)
	  end

	  it 'returns status code 200' do
	  	expect(response).to have_http_status(200)
	  end

	end
	context 'when the record not exists' do
	  
	  let(:todo_id){100}
	  
	  it 'returns status code 404' do
	  	expect(response).to have_http_status(404)
	  end
	  
	  it 'returns a not found message' do 
	  	expect(response.body).to match(/Couldn't find Todo/)
	  end  	
	end	
  end

  # test suit for POST /todos - CREATE NEW RECORD
  describe "POST /todos" do
    # let valid payload
	let(:valid_attributes) { {title: 'Learn Elm', created_by: '1'} }
	
	context "when the request is valid" do
	  before { post '/todos', {params: valid_attributes} } 
	  
	  it "created todos" do
	  	expect(json['title']).to eq('Learn Elm')
	  end

	  it "returns status code 201" do
	  	expect(response).to have_http_status(201)
	  end	
	end
	context "when the request is invalid" do

	  before {post '/todos', params: {title: 'Titulon'} }
	  it "returns status code 422" do
	  	expect(response).to have_http_status(422)
	  end

	  it "returns a validation failure message" do
	    expect(response.body).to match(/Validation failed: Created by can't be blank/)
	  end	
	end	
  end
    
  # Test suite for PUT /todos/:id - UPDATE RECORD
  describe "PUT /todos/:id" do
    let(:valid_attributes) { { title: 'Shopping' } }	
	
	context "when is sucesfully updated" do

	  before { put "/todos/#{todo_id}", params: valid_attributes }
	  
	  it "updates record" do
	  	expect(json['title']).to eq('Shopping')
	  end
	  
	  it "returns status code 200" do
	  	expect(response).to have_http_status(200)
	  end	
	end
	context "when request attributes are invalid" do
	  before { put "/todos/#{todo_id}", params: {title:nil, created_by: nil} }
	  
	  it "returns status code 422" do
	  	expect(response).to have_http_status(422)
	  end
	  
	  it "returns failure message when title is null" do
	    expect(json['errors']['title']).to include("can't be blank")	
	  end

	  it "returns failure message when created_by is null" do
	    expect(json['errors']['created_by']).to include("can't be blank")	
	  end	
	end
  end
	# Tes suit for DELETE /todos/:id
	describe "DELETE /todos/:id" do
	  before {delete "/todos/#{todo_id}"  }	
	  it "returns status code 204" do
	  	expect(response).to have_http_status(204)
	  end	
	end	
end 