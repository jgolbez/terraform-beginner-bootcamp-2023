require 'sinatra'
require 'json'
require 'pry'
require 'active_model'

# Mock database/state for server by setting global variable, dev only
$home = {}

# Ruby class including validation from activerecord representing Home resource as a Ruby object 
class Home
  #Part of Ruby on Rails used as ORM - Object Relational Manager, module provides validations
  #Prod Terratowns server is using Rails and uses mostly identical validations
  #https://guides.rubyonrails.org/active_model_basics.html

  include ActiveModel::Validations
  # create virtual attributes to be stored on this object
  # set getter and setter eg 
  #home = new Home() #setter
  #home.town()= getter
  attr_accessor :town, :name, :description, :domain_name, :content_version

  validates :town, presence: true, inclusion: { in: [
    'cooker-cove',
    'melomaniac-mansion',
    'video-valley',
    'the-nomad-pad',
    'gamers-grotto'
  ] }
  #visible to all
  validates :name, presence: true
  #visible to all
  validates :description, presence: true
  #lock down to cloudfront only
  validates :domain_name, 
    format: { with: /\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
    # uniqueness: true, 
  #content version must be an integer
  #check incremental version in controller  
  validates :content_version, numericality: { only_integer: true }
end

#extending a class from Sinatra Base to turn class into SInatra framework
class TerraTownsMockServer < Sinatra::Base

  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end

  def x_access_code
    '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  def x_user_uuid
    'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    #https://swagger.io/docs/specification/authentication/bearer-authentication/  
    auth_header = request.env["HTTP_AUTHORIZATION"]
    # check if auth header exists
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    #Does token match acceptable token
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    #was uuid in payload?
    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    #did code/uuid match what is expected
    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end

  # CREATE
  post '/api/u/:user_uuid/homes' do
    ensure_correct_headings()
    find_user_by_bearer_token()
    #puts will print to terminal
    puts "# create - POST /api/homes"

    begin
      #sinatra doesnt automatically parse json as params so we manually parse it
      payload = JSON.parse(request.body.read)
    #try/except - catch errors
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data and assign to variables for work with in code
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]
    town = payload["town"]

    #print variables to console for debug
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"

    # create home class/model and set attributes
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    
    #ensure validation passes or raise error
    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    #generate uuid for created Home object
    uuid = SecureRandom.uuid
    puts "uuid #{uuid}"
    #mock save to mock database which is the global variable
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }
    #return uuid to access later
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
    #does uuid match what is in db
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE
  #similar to create except expects uuid to exist already
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    home = Home.new
    home.town = $home[:town]
    $home[:name] = name
    $home[:description] = description
    home.domain_name = $home[:domain_name]
    $home[:content_version] = content_version
    unless home.valid?
      error 422, home.errors.messages.to_json
    end
    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  #delete from mock db
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end
    uuid = $home[:uuid]
    $home = {}
    { uuid: uuid }.to_json
  end
end
# actually runs the server
TerraTownsMockServer.run!