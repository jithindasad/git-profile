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
    if File.zero?(profiles)
      users = {users: [{username: "#{username}", email: "#{email}"}]}
      File.open(profiles, "w") { |file| file.write(users.to_yaml) }
    else
      if user_exists?(email)
        say("User already exists!")
        exit
      end
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
      profiles = File.join(Dir.home, "/.git-profile/profiles.yml")
      if File.exist?(profiles) && !File.zero?(profiles)
        users = YAML.load(File.read(profiles))
        users[:users].each_with_index { |user, index| say("#{index + 1}. #{user[:username]} <#{user[:email]}>") }
      else
        say("No git profiles found. You can add a git profile with `$git-profile add` command .")
      end
    end

    desc "use [username]", "Set the global git profile."
    def use(username)
      profiles = File.join(Dir.home, "/.git-profile/profiles.yml")
      config_path = File.join(Dir.home, ".gitconfig")
      if File.exist?(profiles) && !File.zero?(profiles)
        users = YAML.load(File.read(profiles))
        user = users[:users].filter { |user| user[:username] == username }
        if user
          File.open(config_path, 'w') {|file| file.truncate(0) } if File.exist?(config_path)
          run("git config --global user.name #{user.first[:username]}")
          run("git config --global user.email #{user.first[:email]}")
          say("git credentials has been updated.")
        else
          say("No git profiles with username #{username} was found. See all available profiles with `$git-profile list` command .")
        end
      else
        say("No git profiles with username #{username} was found. See all available profiles with `$git-profile list` command .")
      end
    end

    desc "delete [username]", "Remove a specific git profile"
    def delete(username)
      profiles = File.join(Dir.home, "/.git-profile/profiles.yml")

      if File.exist?(profiles) && !File.zero?(profiles)
        users = YAML.load(File.read(profiles))
        user = users[:users].filter { |user| user[:username] == username }

        unless user.empty?
          users[:users].delete(user.first)
          say("User #{user.first[:username]} <#{user.first[:email].to_s}> has been deleted!")
          if users[:users].empty?
            File.open(profiles, 'w') {|file| file.truncate(0) } 
          else
            File.open(profiles, "w") { |file| file.write(users.to_yaml) }
          end
        else
          say("No git profiles with username #{username} was found. You can see all available profiles with `$git-profile list` command .")
        end
      else
        say("No git profiles found. You can add a git profile with `$git-profile add` command .")
      end
    end

    desc "reset", "Deletes all data and reset."
    def reset
      profiles = File.join(Dir.home, "/.git-profile/profiles.yml")
      config_path = File.join(Dir.home, ".gitconfig")
      File.open(profiles, 'w') {|file| file.truncate(0) } if File.exist?(profiles) && !File.zero?(profiles)
      File.open(config_path, 'w') {|file| file.truncate(0) } if File.exist?(config_path)
      say("reset successfull!")
    end

    desc "whoami", "Show the global git profile"
    def whoami
      config_path = File.join(Dir.home, ".gitconfig")
      if File.exist?(config_path) && !File.zero?(config_path)
        print("username: ")
        username = run("git config user.name", config = {:verbose => false})
        print("email: ")
        email = run("git config user.email", config = {:verbose => false})
      else
        say("No git profiles found. You can add a git profile with `$git-profile use` command .")
      end
    end
 end
end

Profile::CLI.start(ARGV)
