require 'rails_helper'

RSpec.describe BirdsController, type: :controller do

  describe 'GET /index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(HttpStatusCodeEnum::SUCCESS)
    end

    it 'returns ids of the visible birds' do
      visible_bird = Bird.create!({:name => 'parrot', :family => 'bird', :continents => ['asia'], :visible => true})
      invisible_bird = Bird.create!({:name => 'crow', :family => 'bird', :continents => ['asia'], :visible => false})
      get :index
      expected_response = [visible_bird.id.to_s]
      expect(response).to have_http_status(HttpStatusCodeEnum::SUCCESS)
      expect(JSON(response.body)).to eq(expected_response)
    end
  end

  describe 'GET /birds/:id' do
    context 'when visible bird exists' do
      it 'responds successfully with an HTTP 200 status code' do
        visible_bird = Bird.create!({:name => 'parrot', :family => 'bird', :continents => ['asia'], :visible => true})
        get :show, params: {id: visible_bird.id.to_s}
        expect(response).to be_success
        expect(response).to have_http_status(HttpStatusCodeEnum::SUCCESS)
        expect(JSON(response.body)['id']).to eq(visible_bird.id.to_s)
        expect(response).to match_response_schema('get-birds-id-response')
      end
    end

    context 'when an invisible bird exists' do
      it 'responds successfully with an HTTP 200 status code' do
        invisible_bird = Bird.create!({:name => 'parrot', :family => 'bird', :continents => ['asia']})
        get :show, params: {id: invisible_bird.id.to_s}
        expect(response).to be_success
        expect(response).to have_http_status(HttpStatusCodeEnum::SUCCESS)
        expect(JSON(response.body)['id']).to eq(invisible_bird.id.to_s)
        expect(response).to match_response_schema('get-birds-id-response')
      end
    end


    context 'when bird does not exists' do
      it 'responds with an HTTP 404 status code' do
        get :show, params: {id: '1'}
        expect(response).to have_http_status(HttpStatusCodeEnum::NOT_FOUND)
      end
    end
  end

  describe 'POST /birds' do
    it 'responds with an HTTP 400 status code when required parameters are missing' do
      post :create, params: {}
      expected_response = {'name' =>["can't be blank"],
                           'family' =>["can't be blank"],
                           'continents' =>["can't be blank"]}.to_json
      expect(response).to have_http_status(HttpStatusCodeEnum::BAD_REQUEST)
      expect(response.body).to eq(expected_response)
    end

    context 'when visible is not set' do
      it 'creates bird with visible false and responds with an HTTP 201 status code' do
        post :create, params: {:name => 'parrot', :family => 'bird', :continents => ['asia']}
        created_bird = Bird.find(JSON(response.body)['id'])
        expect(response).to have_http_status(HttpStatusCodeEnum::CREATED)
        expect(JSON(response.body)).to eq({'id' => created_bird.id.to_s})
        expect(created_bird.visible).to eq(false)
      end
    end

    context 'when visible is set' do
      it 'creates bird with visible true and responds with an HTTP 201 status code' do
        post :create, params: {:name => 'parrot', :family => 'bird', :continents => ['asia'], :visible => true}
        created_bird = Bird.find(JSON(response.body)['id'])
        expect(response).to have_http_status(HttpStatusCodeEnum::CREATED)
        expect(JSON(response.body)).to eq({'id' => created_bird.id.to_s})
        expect(created_bird.visible).to eq(true)
      end
    end
  end

  describe 'DELETE /birds/:id' do
    it 'responds with an HTTP 404 status code when bird not found' do
      delete :destroy, params: {id: 1}
      expect(response).to have_http_status(HttpStatusCodeEnum::NOT_FOUND)
    end

    it 'deletes bird and responds with an HTTP 200 status code' do
      created_bird = Bird.create!({:name => 'parrot', :family => 'bird', :continents => ['asia']})
      post :destroy, params: {:id => created_bird.id.to_s}
      expect(response).to have_http_status(HttpStatusCodeEnum::SUCCESS)
    end
  end




end
