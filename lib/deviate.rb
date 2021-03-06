# encoding: UTF-8
# !/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/support'
require 'compass'
require 'json'
require 'rdiscount'
require 'html_truncator'

require_relative 'blog_routes'
require_relative 'post_routes'

# top level class comment?
module AF
  class Deviate < Sinatra::Application
    set :root, File.expand_path('../', File.dirname(__FILE__))
    set :views, File.expand_path('../', File.dirname(__FILE__)) + '/lib/views'
    set :scss, load_paths: ['public/sass']
    set :environment, :production

    register Sinatra::AssetPack
    register Sinatra::CompassSupport
    register AF::PostRoutes
    register AF::BlogRoutes

    assets do
      serve '/js',     from: 'public/js'  # Default
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
        '/css/footnote-button.css'
      ]

      js_compression :uglify    # :jsmin | :yui | :closure | :uglify
      css_compression :sass   # :simple | :sass | :yui | :sqwish
      prebuild true
    end

    def all_posts
      posts = []
      Dir.glob('posts/*/*/*.json') do |postconfig| # note one extra "*"
        posts.push(postconfig)
      end
      posts
    end

    def ready_posts
      the_posts = []
      posts = all_posts
      posts.each do |post|
        the_post = JSON.parse(File.read(post))
        the_posts.push(the_post) if the_post['draft'] != true
      end
      the_posts
    end
  end
end
