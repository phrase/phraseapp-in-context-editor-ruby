# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'phraseapp-in-context-editor-ruby/version'

Gem::Specification.new do |s|
  s.name = "phraseapp-in-context-editor-ruby"
  s.version = PhraseApp::InContextEditor::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Dynport GmbH"]
  s.email = ["info@phraseapp.com"]
  s.homepage = "https://phraseapp.com"
  s.summary = %q{Translation management solution for web and mobile applications}
  s.licenses = ['MIT']
  s.description = %q{PhraseApp In-Context-Editor allows you to edit translations directly on the website. More information: phraseapp.com}
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "phraseapp-in-context-editor-ruby"
  git_files = `git ls-files | grep -v spec/`.split("\n") rescue ''
  s.files = git_files
  s.test_files = s.files.grep(%r{^(spec)/})
  s.require_paths = ["lib"]
  s.add_dependency('json', '~> 1.8')
  s.add_dependency('i18n', '~> 0.7')
  s.add_dependency('phraseapp-ruby', '~> 1.2.7')
  s.add_development_dependency('rspec', '~> 3.2')
  s.add_development_dependency('webmock', '~> 1.21')
  s.add_development_dependency('vcr', '~> 2.9')
  s.add_development_dependency('timecop', '~> 0.7')
  s.add_development_dependency('rails', '~> 4.2')
  s.add_development_dependency('github_changelog_generator')
end
