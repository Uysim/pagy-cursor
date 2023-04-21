
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pagy_cursor/version"

Gem::Specification.new do |spec|
  spec.name          = "pagy_cursor"
  spec.version       = PagyCursor::VERSION
  spec.authors       = ["Uysim"]
  spec.email         = ["uysimty@gmail.com"]

  spec.summary       = "cursor paginations for pagy"
  spec.description   = "use pagy for cursor paginations with rails"
  spec.homepage      = "https://github.com/Uysim/pagy-cursor"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "pagy", ">= 6", "< 7"
  spec.add_dependency "activerecord", ">= 5"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
