# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "phraseapp-in-context-editor-ruby"
  s.version = "2.0.0"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 3.1.0"
  s.authors = ["Phrase"]
  s.email = ["info@phrase.com"]
  s.homepage = "https://phrase.com"
  s.summary = "Translation management solution for web and mobile applications"
  s.licenses = ["MIT"]
  s.description = "Phrase In-Context-Editor allows you to edit translations directly on the website. More information: phrase.com"
  s.required_rubygems_version = ">= 1.3.6"
  git_files = begin
    `git ls-files | grep -v spec/`.split("\n")
  rescue
    ""
  end
  s.files = git_files
  s.require_paths = ["lib"]
  s.add_dependency("json", "~> 2.0")
  s.add_dependency("i18n", "~> 1.0")
  s.add_dependency("request_store", "~> 1.2")
  s.add_development_dependency("rspec", "~> 3.0")
  s.add_development_dependency("rails", "~> 7.0")
  s.add_development_dependency("github_changelog_generator", "~> 1.16")
end
