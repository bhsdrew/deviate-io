#!/usr/bin/env ruby

require "rubygems"
require "sinatra/base"
require 'sinatra/assetpack'
require 'sinatra/support'
require 'compass'
require 'json'
require 'rdiscount'

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
	      '/js/vendor/bigfoot.js',
        '/js/vendor/rainbow.js',
        '/js/vendor/language/*',
	      '/js/main.js'
	    ]

	    css :main, '/css/deviate.css', [
	      '/css/normalize.css',
	      '/css/foundation.css',
	      '/css/main.css',
	      '/css/footnote-button.css',
        '/css/themes/solarized-light.css'
	    ]

	    js_compression  :uglify    # :jsmin | :yui | :closure | :uglify
	    css_compression :sass   # :simple | :sass | :yui | :sqwish
	    prebuild true 
	  end

	public
	def on_heroku?
  		ENV['I_AM_HEROKU']
	end

	allposts = []
	Dir.glob("posts/*/*/*.json") do |postconfig| # note one extra "*"
	  	allposts.push(postconfig)
	end
	@@thePosts = Array.new()
	for post in allposts
		@@thePosts.push(JSON.parse(File.read(post)))

	end
	
	#single post route
	get '/post/:year/:month/:slug' do
		config = File.read("posts/#{params[:year]}/#{params[:month]}/#{params[:slug]}.json")
		content = File.read("posts/#{params[:year]}/#{params[:month]}/#{params[:slug]}.markdown")
		post = {
			:post => JSON.parse(config),
			:content => RDiscount.new(content).to_html
		}
		erb :post , :layout => :layout, locals: post
	end

	#helper route for listing out all articles
	get '/archive' do
		sorted = @@thePosts.sort_by { |k| k["pubdate"] }.reverse
		content = {:posts => sorted}
		erb :archive, :layout => :layout, locals: content
	end

	#home route
	get '/' do
		sorted = @@thePosts.sort_by { |k| k["pubdate"] }.reverse
		content = File.read("posts/#{sorted[0]['year']}/#{sorted[0]['month']}/#{sorted[0]['slug']}.markdown")
		post = {
			:post => sorted[0],
			:content => RDiscount.new(content).to_html
		}
		config = {:title => "Self deploying blog",
				  :recentPost => post}

		erb :index , :layout => :layout, locals: config
	end

	get '/site' do 
		ENV['I_AM_HEROKU']
	end

end
