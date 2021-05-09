require_relative 'lib/git/profile/version'

Gem::Specification.new do |spec|
  spec.name          = "git-profile"
  spec.version       = Git::Profile::VERSION
  spec.authors       = ["jithindasad"]
  spec.email         = ["jithindasad@gmail.com"]

  spec.description   = "git-profile is a CLI tool which allows you to switch between multiple git profiles interactively."
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/jithindasad/git-profile"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.add_dependency "thor", "~> 1.1"
  

  spec.metadata["allowed_push_host"] = "https://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/jithindasad/git-profile/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
