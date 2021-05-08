require "git/profile/version"
require 'thor'
require 'yaml'

module Utilities

  def user_exists?(email)
    profiles = File.join(Dir.home, "/.git-profile/profiles.yml")
    users = YAML.load(File.read(profiles))
    emails = users[:users].filter do |user| 
      user[:email] == email
    end
    emails.empty? ? false : true
  end

  def fetch_user_data
    username = ask("enter your username:")
    email = ask("enter your email:")

    unless email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i 
      say("Invalid email address, Try Again! \n")
      self.fetch_user_data
    end

    return [username, email]
  end

  def save(username, email)
    profiles = File.join(Dir.home, "/.git-profile/profiles.yml")

    if user_exists?(email)
      say("User already exists!")
      exit
    end

    if File.zero?(profiles)
      users = {users: [{username: "#{username}", email: "#{email}"}]}
      File.open(profiles, "w") { |file| file.write(users.to_yaml) }
    else
      users = YAML.load(File.read(profiles))
      user = {username: "#{username}", email: "#{email}"}
      users[:users].push(user)
      File.open(profiles, "w") { |file| file.write(users.to_yaml) }
    end
    say("User #{username} <#{email}> has been added!")
  end

end

module Profile
 class CLI < Thor
  include Thor::Actions
  include Utilities

    def self.exit_on_failure?
      true
    end

    desc "add", "Adds a new git profile"
    def add
      profiles = File.join(Dir.home, "/.git-profile/profiles.yml")
      profile_directory = File.join(Dir.home, ".git-profile")
      username, email = fetch_user_data

      if File.exist?(profiles)
        save(username, email)
      else
        Dir.mkdir(profile_directory) unless Dir.exist?(profile_directory)
        create_file "#{File.join(Dir.home, ".git-profile/profiles.yml")}"
        username, email = fetch_user_data
        save(username, email)
      end
    end

    desc "list", "List all available git profiles."
    def list
      # TODO
    end

    desc "use [username]", "Set the global git profile."
    def use(username)
      # TODO
    end

    desc "delete [username]", "Remove a specific git profile"
    def delete(username)
      # TODO
    end

    desc "reset", "Deletes all data and reset."
    def reset
      # TODO
    end

    desc "whoami", "Show the global git profile"
    def whoami
      print("username: ")
      username = run("git config user.name", config = {:verbose => false})
      print("email: ")
      email = run("git config user.email", config = {:verbose => false})
    end
 end
end

Profile::CLI.start(ARGV)
