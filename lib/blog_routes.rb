module AF
  module BlogRoutes
    def self.registered(app)
      # home route
      app.get '/' do
        posts = ready_posts
        sorted = posts.sort_by { |k| k['pubdate'] }.reverse
        path = "#{sorted[0]['year']}/#{sorted[0]['month']}/#{sorted[0]['slug']}"
        content = File.read("posts/#{path}.markdown")
        post = {
          post: sorted[0],
          content: HTML_Truncator.truncate(RDiscount.new(content).to_html, 50)
        }
        config = { title: 'Self deploying blog',
                   recentPost: post }

        erb :index , layout: :layout, locals: config
      end

      app.get '/projects' do
        erb :projects, layout: :layout
      end

      app.get '/me' do
        erb :about, layout: :layout
      end

      app.get '/site' do
        ENV['I_AM_HEROKU']
      end
    end
  end
end