# frozen_string_literal: true

require_relative 'lib/suika/version'

Gem::Specification.new do |spec|
  spec.name          = 'suika'
  spec.version       = Suika::VERSION
  spec.authors       = ['yoshoku']
  spec.email         = ['yoshoku@outlook.com']

  spec.summary       = 'Suika is a Japanese morphological analyzer written in pure Ruby.'
  spec.description   = 'Suika is a Japanese morphological analyzer written in pure Ruby.'
  spec.homepage      = 'https://github.com/yoshoku/suika'
  spec.license       = 'BSD-3-Clause'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/yoshoku/magro/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rambling-trie', '~> 2.1'
end
