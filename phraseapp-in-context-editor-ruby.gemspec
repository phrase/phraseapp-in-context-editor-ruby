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
  s.summary = %q{The best way to manage i18n.}
  s.description = %q{PhraseApp In-Context-Editor allows you to edit translations directly on the website. More information: phraseapp.com}
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "phraseapp-in-context-editor-ruby"
  git_files = `git ls-files | grep -v spec/`.split("\n") rescue ''
  s.files = git_files
  s.test_files = s.files.grep(%r{^(spec)/})
  s.require_paths = ["lib"]
  s.add_dependency('json')
  s.add_dependency('i18n')
  s.add_dependency('phraseapp-ruby')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('webmock')
  s.add_development_dependency('vcr')
  s.add_development_dependency('timecop')
  s.add_development_dependency('genspec')
  s.add_development_dependency('rails')
end
