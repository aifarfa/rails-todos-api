require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  # initialize test data
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  # GET /todos
  describe 'GET /todos' do

    before {get '/todos'}

    it 'returns todos' do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code: 200' do
      expect(response).to have_http_status(200)
    end
  end

  # GET /todos/:id
  describe 'GET /todos/:id' do
    before {get "/todos/#{todo_id}"}

    context 'when record exists' do
      it 'returns todo' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code: 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record doesnot exists' do
      let(:todo_id) { 100 }

      it 'returns 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # POST /todos
  describe 'POST /todos' do
    # valid payload
    let(:payload) { { title: 'Testing API', created_by: '1' } }

    context 'when request is valid' do
      before { post '/todos', params: payload }

      it 'creates a given todo' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['title']).to eq('Testing API')
      end

      it 'returns 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      before { post '/todos', params: { title: 'Should fail'} }

      it 'returns 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns validation failed message' do
        puts response.body
        expect(response.body).to match(/Validation failed/)
      end
    end
  end

  # PUT /todos
  describe 'PUT /todos' do
    let(:payload) { { title: 'Awesome!' } }

    context 'when record exists' do
      before { put "/todos/#{todo_id}", params: payload }

      it 'returns 204 no content' do
        expect(response).to have_http_status(204)
      end

      it 'response no content' do
        expect(response.body).to be_empty
      end
    end

    context 'when record does not exists' do
      before { put "/todos/100", params: payload }

      it 'returns 404 not found' do
        expect(response).to have_http_status(404)
      end
    end
  end

end
