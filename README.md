# Phraseapp #
[![Code Climate](https://codeclimate.com/github/phraseapp-ruby-in-context-editor/phrase.png)](https://codeclimate.com/github/phraseapp-ruby-in-context-editor/phrase)
[![Build Status](https://secure.travis-ci.org/phraseapp-ruby-in-context-editor/phrase.png)](http://travis-ci.org/phraseapp-ruby-in-context-editor/phrase)

Phraseapp is a translation management software. Set up a professional translation process to boost the quality of your translations with our powerful In-Context Editor or simply share and edit locale files with your team.

You can order professional translations through Phraseapp or work with your own translators. Our platform supports various programming languages and frameworks. Such as [Ruby on Rails, Symfony, Zend Framework, iOS, Android and many more](https://phraseapp.com/docs/general/supported-platforms).

[Try out Phraseapp for free](https://phraseapp.com/features) and start translating your app!

### In-Context Editor ###
Phraseapp comes with an In-Context editor that allows you to translate directly on your website. See our documentation on how to set it up: [In-Context Editor Setup](http://docs.phraseapp.com/guides/in-context-editor/).

### Installation

Install the gem via `gem install`

	gem install phraseapp-phraseapp-ruby-in-context-editor
	
or add it to your `Gemfile` when using bundler:

	gem 'phraseapp-phraseapp-ruby-in-context-editor'

and install it	

	$ bundle install
	
That's it!

### Initialization

Install phraseapp-ruby-in-context-editor by executing the Rails generator:

	bundle exec rails generate phraseapp-ruby-in-context-editor:install --access-token=<YOUR_TOKEN> --project-id=<YOUR_PROJECT_ID>
	
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

## Partner-Integrations
* [Integrate Phraseapp with Ruby Motion](https://github.com/phrase/motion-phrase)
* [Integrate Phraseapp as a Heroku Add-on](https://addons.heroku.com/phrase)
* [Integrate Phraseapp as a Cloudcontrol Add-on](https://phraseapp.com/docs/cloudcontrol/introduction)
