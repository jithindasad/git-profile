require "git/profile/version"
require 'thor'

module Profile
 class CLI < Thor
    desc "add", "Adds a new git profile"
    def add
      # TODO
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
      # TODO
    end
 end
end

Profile::CLI.start(ARGV)
