class Deviate < Sinatra::Application
	post '/post-receive' do
	  data = JSON.parse(params[:payload])
	  # if data["repository"]["private"]
	  #   "freak out"
	  # end
	  url = data["repository"]["url"]
	  #GitPusher.deploy(url)
	  "Success!"
	end
end
