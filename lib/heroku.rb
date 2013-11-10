#if ENV['I_AM_HEROKU']
#  Heroku::Auth.instance_eval do
#    # Autologin
#    @credentials = ['bhsdrew', 'fcca56b1-d3c2-4fdb-9b44-d0e9e1fb1233']
#    # Set up keys if there aren't any
#    key_path = "#{home_directory}/.ssh/id_rsa.pub"
#    if available_ssh_public_keys.empty?
##      puts "Generating New Pair"
#      generate_ssh_key("id_rsa")
#      associate_key(key_path)
#    end
#    ::CURRENT_SSH_KEY = File.read(key_path)
#  end
#end