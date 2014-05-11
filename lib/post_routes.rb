module AF
  module PostRoutes
    def self.registered(app)
      # single post route
      app.get '/post/:year/:month/:slug' do
        route = "#{params[:year]}/#{params[:month]}/#{params[:slug]}"
        config = File.read("posts/#{route}.json")
        content = File.read("posts/#{route}.markdown")
        post = {
          post: JSON.parse(config),
          content: RDiscount.new(content).to_html
        }
        erb :post , layout: :layout, locals: post
      end

      # helper route for listing out all articles
      app.get '/archive' do
        posts = ready_posts
        sorted = posts.sort_by { |k| k['pubdate'] }.reverse
        content = { posts: sorted }
        erb :archive, layout: :layout, locals: content
      end
    end
  end
end