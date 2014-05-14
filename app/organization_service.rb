require 'sinatra'
require 'mongoid'
require 'json'
require './config/settings'
require './app/models'

Mongoid.load!('./config/mongoid.yml')

before do
  content_type :json
  ssl_whitelist = ['/calendar.ics']
  if settings.force_ssl && !request.secure? && !ssl_whitelist.include?(request.path_info)
    halt 400, "Please use SSL at https://#{settings.host}"
  end
end

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'web_service_user' and password == 'messingaroundinboats'
end

get '/' do
  'Welcome to the Organization Service!'
end


get '/organizations/.json' do
  begin
    Organization.all.to_json
  rescue Exception => e
    halt 500, e.message
  end
end

post '/organizations/.json' do
  begin
    org = Organization.new(json_params)
    if org.save
      org.to_json
    else
      halt 500, org.errors.full_messages[0]
    end
  rescue Exception => e
    halt 500, e.message
  end
end

get '/organizations/:id.json' do
  begin
    org = Organization.find(params[:id])
    if org.nil?
      raise Exception, 'Organization not found.'
    else
      org.to_json
    end
  rescue Exception => e
    halt 500, e.message
  end
end

put '/organizations/:id.json' do
  begin
    org = Organization.find(params[:id])
    if org.update_attributes!(json_params)
      org.to_json
    else
      halt 500, org.errors.full_messages[0]
    end
  rescue Exception => e
    halt 500, e.message
  end
end

delete '/organizations/:id.json' do
  begin
    org = Organization.find(params[:id])
    if org.destroy
      { :id => org.id, :deleted => true }.to_json
    else
      halt 500, org.errors.full_messages[0]
    end
  rescue Exception => e
    halt 500, e.message
  end
end


private

def json_params
  JSON.parse(request.env['rack.input'].read, symbolize_names: true)
end