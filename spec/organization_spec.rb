require 'spec_helper'
require './app/organization_service'

describe 'Organization Service' do
  before(:each) do
    authorize 'web_service_user', 'messingaroundinboats'
  end
  
  after(:each) do
    Organization.delete_all
  end

  it 'should return all the organizations' do
    org1 = create(:organization)
    org2 = create(:organization)
    get '/organizations/.json'
    response = parse_json(last_response.body)
    response[0][:name].should eq(org1.name)
  end

  it 'should create an organization' do
    org = { name: 'Fake Organization' }
    post '/organizations/.json', org.to_json
    response = parse_json(last_response.body)
    response[:name].should eq(org[:name])
  end

  it 'should get a particular organization' do
    org = create(:organization)
    get "/organizations/#{org.id}.json"
    response = parse_json(last_response.body)
    response[:name].should eq(org.name)
  end

  it 'should update an organization' do
    org = create(:organization)
    put "/organizations/#{org.id}.json", { name: 'New Org Name' }.to_json
    response = parse_json(last_response.body)
    response[:name].should eq('New Org Name')
  end

  it 'should delete an organization' do
    org = create(:organization)
    delete "/organizations/#{org.id}.json"
    response = parse_json(last_response.body)
    response[:deleted].should eq(true)
    Organization.where(id: org.id).exists?.should eq(false)
  end
end