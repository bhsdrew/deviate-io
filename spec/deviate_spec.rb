ENV['RACK_ENV'] = 'test'

require 'deviate'
require 'rspec'
require 'rack/test'

describe 'Deviate.io App' do
	include Rack::Test::Methods

	def app
		Deviate
	end

	it "should GET '/'" do
		get '/'
		last_response.status.should be(200)
	end

	it "should GET '/about'" do
		get '/'
		last_response.status.should be(200)
	end

	it "should GET '/projects'" do
		get '/projects'
		last_response.status.should be(200)
	end
  it "should GET '/archive'" do
    get '/archive'
    last_response.status.should be(200)
  end

	it "should GET '/post/2013/12/style-guide" do
		get '/post/2013/12/style-guide'
		last_response.status.should be(200)
	end

  it "should GET '/post/2013/12/first-post" do
    get '/post/2013/12/first-post'
    last_response.status.should be(200)
  end
	
end