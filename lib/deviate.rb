#!/usr/bin/env ruby

require "rubygems"
require "sinatra/base"
require 'sinatra/assetpack'


class Deviate < Sinatra::Application
	 set :root, File.expand_path("../", File.dirname(__FILE__))
     set :views, File.expand_path("../", File.dirname(__FILE__)) + '/lib/views'

	register Sinatra::AssetPack

	  assets {
	    serve '/js',     from: 'public/js'        # Default
	    serve '/css',    from: 'public/css'       # Default
	    serve '/images', from: 'public/images'    # Default

	    # The second parameter defines where the compressed version will be served.
	    # (Note: that parameter is optional, AssetPack will figure it out.)
	    js :app, '/js/app.js', [
	      '/js/vendor/**/*.js',
	      '/js/lib/**/*.js'
	    ]

	    css :application, '/css/application.css', [
	      '/css/screen.css'
	    ]

	    js_compression  :uglify    # :jsmin | :yui | :closure | :uglify
	    css_compression :sass   # :simple | :sass | :yui | :sqwish
	  }



  get '/' do
    	erb :index , :layout => :layout
  end

end