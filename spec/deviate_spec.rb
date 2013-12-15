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
	
end