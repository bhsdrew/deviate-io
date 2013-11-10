class Deviate < Sinatra::Application
	get '/public_key' do
	  ::CURRENT_SSH_KEY
	end

	get '/status' do
	  c = GitPusher.local_state('https://github.com/bhsdrew/deviate-io')
	  puts "SHA: #{c.sha} | Date: #{c.date}"
	  "SHA: #{c.sha} | Date: #{c.date}"
	end

	get '/nuke-repos' do
	  `rm -r repos`
	  puts "nuked!"
	  "nuked!"
	end

	get '/force-push' do
	  GitPusher.deploy('https://github.com/bhsdrew/deviate-io')
	  puts "Success!"
	  "Success!"
	end

	post '/post-receive' do
	  data = JSON.parse(params[:payload])
	  # if data["repository"]["private"]
	  #   "freak out"
	  # end
	  url = data["repository"]["url"]
	  GitPusher.deploy(url)
	  puts "Success!"
	end
end
