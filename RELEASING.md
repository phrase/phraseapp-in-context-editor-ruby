# Release

1. Bump the version to the desired number in lib/phraseapp-in-context-editor-ruby/version.rb. Make sure you're following semantic versioning. 
2. Run `bundle` and commit Gemfile.lock including the new version of the gem
3. Make sure the tests pass
4. Tag the new version on GitHub
5. Update the CHANGELOG by running `$ github_changelog_generator` and commit the new `CHANGELOG`
6. Build the gem by running `gem build phraseapp-in-context-editor-ruby.gemspec`
7. Push the gem to Rubygems by running `gem push phraseapp-in-context-editor-ruby-<VERSION>.gem`
8. Done!
