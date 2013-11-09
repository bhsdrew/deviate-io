#!/usr/bin/env ruby

require "rubygems"
require "sinatra/base"
require 'sinatra/assetpack'
require 'sinatra/support'
require 'compass'
require 'minigit'
require 'git'
require 'heroku'

class Deviate < Sinatra::Application
	 set :root, File.expand_path("../", File.dirname(__FILE__))
     set :views, File.expand_path("../", File.dirname(__FILE__)) + '/lib/views'
     set :scss, { :load_paths => [ "public/sass" ] }

	register Sinatra::AssetPack
	register Sinatra::CompassSupport

	  assets do
	    serve '/js',     from: 'public/js'        # Default
	    serve '/css',    from: 'public/sass'       # Default
	    serve '/images', from: 'public/images'    # Default
	    serve '/fonts', from: 'public/fonts'    # Default

	    # The second parameter defines where the compressed version will be served.
	    # (Note: that parameter is optional, AssetPack will figure it out.)
	    js :main, '/js/deviate.js', [
	      '/js/vendor/foundation/foundation.js',
	      '/js/main.js'
	    ]

	    css :main, '/css/deviate.css', [
	      '/css/normalize.css',
	      '/css/foundation.css',
	      '/css/main.css'
	    ]

	    js_compression  :uglify    # :jsmin | :yui | :closure | :uglify
	    css_compression :sass   # :simple | :sass | :yui | :sqwish
	    prebuild true 
	  end

	public
	def on_heroku?
  		ENV['I_AM_HEROKU']
	end


  get '/' do
    	erb :index , :layout => :layout
  end

  get '/site' do 
  	ENV['I_AM_HEROKU']
  end

  get '/status' do 
  		if !@on_heroku
  			return "LIVE"
  		end
  		MiniGit.fetch
		status = MiniGit::Capturing.branch :v => true
		print status
		statuscount = status.scan(/\[([^\]])+\]/).last

		if statuscount 
			"Update needed"
		end
  end

  get '/update' do
  		if !@on_heroku
  			return "LIVE"
  		end
  		update = MiniGit::Capturing.pull
  		update
  end


  #git hooks
  get '/public_key' do
  ::CURRENT_SSH_KEY
end

get '/status' do
  c = GitPusher.local_state(ENV['GITHUB_REPO'])
  "SHA: #{c.sha} | Date: #{c.date}"
end

get '/nuke-repos' do
  `rm -r repos`
  "nuked!"
end

get '/force-push' do
  GitPusher.deploy(ENV['GITHUB_REPO'])
  "Success!"
end

post '/post-receive' do
  data = JSON.parse(params[:payload])
  # if data["repository"]["private"]
  #   "freak out"
  # end
  url = data["repository"]["url"]
  GitPusher.deploy(url)
  "Success!"
end

require_relative 'lib/init'

end