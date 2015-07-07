# Phraseapp #
[![Code Climate](https://codeclimate.com/github/phrase/phraseapp-in-context-editor-ruby.png)](https://codeclimate.com/github/phrase/phraseapp-in-context-editor-ruby)
[![Build Status](https://secure.travis-ci.org/phrase/phraseapp-in-context-editor-ruby.png)](http://travis-ci.org/phrase/phraseapp-in-context-editor-ruby)

Phraseapp is a translation management software. Set up a professional translation process to boost the quality of your translations with our powerful In-Context Editor or simply share and edit locale files with your team.

You can order professional translations through Phraseapp or work with your own translators. Our platform supports various programming languages and frameworks. Such as [Ruby on Rails, Symfony, Zend Framework, iOS, Android and many more](https://phraseapp.com/docs/general/supported-platforms).

[Try out Phraseapp for free](https://phraseapp.com/features) and start translating your app!

### In-Context Editor ###
Phraseapp comes with an In-Context editor that allows you to translate directly on your website. See our documentation on how to set it up: [In-Context Editor Setup](http://docs.phraseapp.com/guides/in-context-editor/).

### Installation

Install the gem via `gem install`

	gem install phraseapp-in-context-editor-ruby
	
or add it to your `Gemfile` when using bundler:

	gem 'phraseapp-in-context-editor-ruby'

and install it	

	$ bundle install
	
That's it!

### Initialization

Install phraseapp-in-context-editor-ruby by executing the Rails generator:

	bundle exec rails generate phraseapp-in-context-editor-ruby:install --access-token=<YOUR_TOKEN> --project-id=<YOUR_PROJECT_ID>

  access-token:

  OAuth access-tokens can be limited to specific scopes, and can be revoked by users at any time. You can create and manage OAuth access-tokens in your [profile settings](https://phraseapp.com/me/oauth_access_tokens) in Translation Center or via the [Authorizations API](http://docs.phraseapp.com/api/v2/authorizations).

  project-id:

  The project id can be found in your projects settings in the Translation Center. 
  https://phraseapp.com/<YOUR-PROJECT-NAME>/edit
	
This will:

* create a `in_context_editor.rb` initializer file in `./config/initializers/`

*Using the generator will automatically prepare your Rails application for use with the [In-Context-Editor](https://phraseapp.com/features).*

## Further Information
* [Read the Phraseapp Documentation](http://docs.phraseapp.com/)
* [Software Translation Managemeny with Phraseapp](https://phraseapp.com/features)
* [Get in touch with Phraseapp Team](https://phraseapp.com/contact)

## References
* [Phraseapp API Documentation](http://docs.phraseapp.com/api/v2/)
* [Demo of the In-Context Editor](http://demo.phraseapp.com)
* [Localization Guides and Software Translation Best Practices](http://localize-software.phraseapp.com/)
