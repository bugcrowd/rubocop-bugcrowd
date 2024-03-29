# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/bugcrowd/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-bugcrowd'
  spec.version       = RuboCop::Bugcrowd::VERSION
  spec.authors       = ['Max Schwenk', 'Adam David']
  spec.email         = ['max@bugcrowd.com', 'adam@bugcrowd.com']

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  spec.license       = 'MIT'
  spec.homepage      = 'https://github.com/bugcrowd/rubocop-bugcrowd'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #   spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  # corrector.insert_after fails on 0.79, bump to 0.93 fixes it
  spec.add_development_dependency 'rubocop', '~> 0.93'

  spec.add_runtime_dependency 'rubocop'
end
