
module GitPusher
  require 'git-ssh-wrapper'
  require 'git'
  extend self

  def deploy(github_url)
    raise "Incorrect URL Provided #{github_url}" unless github_url == 'https://github.com/bhsdrew/deviate-io'
    repo = open_or_setup(github_url)
    wrapped_push(repo)
  end

  def open_or_setup(github_url)

    local_folder = "repos/#{Zlib.crc32(github_url)}"

    repo = begin
      Git.open(local_folder).tap do |g|
        g.fetch
        g.remote('origin').merge
      end
    rescue ArgumentError => e
      `rm -r #{local_folder}`
      wrapped_clone(github_url, local_folder)
      retry
    end
    repo.add_remote('heroku', 'git@heroku.com:deviate-io.git') unless repo.remote('heroku').url
    repo
  end

  def wrapped_clone(github_url, local_folder)
    wrapper = GitSSHWrapper.new(:private_key_path => '~/.ssh/deplay_rsa')
    `env #{wrapper.git_ssh} git clone #{github_url} #{local_folder}`
  ensure
    wrapper.unlink
  end

  def wrapped_push(repo, remote='heroku', branch='master')
    wrapper = GitSSHWrapper.new(:private_key_path => '~/.ssh/deplay_rsa')
    `cd #{repo.dir}; env #{wrapper.git_ssh} git push -f #{remote} #{branch}`
  ensure
    wrapper.unlink
  end

  def local_state(github_url)
    repo = open_or_setup(github_url)
    repo.object('HEAD')
  end

end