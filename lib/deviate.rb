#!/usr/bin/env ruby

require "rubygems"
require "sinatra/base"
require 'sinatra/assetpack'
require 'sinatra/support'
require 'compass'


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
	      '/js/vendor/foundation/foundation.js'
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



  get '/' do
    	erb :index , :layout => :layout
  end

end