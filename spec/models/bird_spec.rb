require 'rails_helper'

RSpec.describe Bird, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it 'raises error when name is not present' do
    bird_params = {:family => 'family', :continents => ['continent']}
    expect {Bird.create!(bird_params)}.to raise_error(Mongoid::Errors::Validations) do |error|
      expect(error.message).to include("Name can't be blank")
    end
  end

  it 'raises error when family is not present' do
    bird_params = {:name => 'name', :continents => ['continent']}
    expect {Bird.create!(bird_params)}.to raise_error(Mongoid::Errors::Validations) do |error|
      expect(error.message).to include("Family can't be blank")
    end
  end

  it 'raises error when continents is not present' do
    bird_params = {:name => 'name', :family => 'family'}
    expect {Bird.create!(bird_params)}.to raise_error(Mongoid::Errors::Validations) do |error|
      expect(error.message).to include("Continents can't be blank")
    end
  end


  it 'raises error when continents is empty' do
    bird_params = {:name => 'name', :family => 'family', :continents => []}
    expect {Bird.create!(bird_params)}.to raise_error(Mongoid::Errors::Validations) do |error|
      expect(error.message).to include("Continents can't be blank")
    end
  end

  it 'defaults the value of added field to current timestamp' do
    current_timestamp = Time.now
    allow(Time).to receive(:now) { current_timestamp }
    bird_params = {:name => 'name', :family => 'family', :continents => ['asia']}
    bird_id = Bird.create!(bird_params).id
    created_bird = Bird.find(bird_id.to_s)
    expect(created_bird.added).to eq(current_timestamp.to_s)
  end

  it 'defaults the value of visible field to false' do
    bird_params = {:name => 'name', :family => 'family', :continents => ['asia']}
    bird_id = Bird.create!(bird_params).id
    created_bird = Bird.find(bird_id.to_s)
    expect(created_bird.visible).to be_falsey
  end
end
