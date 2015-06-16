# PhraseApp #
[![Code Climate](https://codeclimate.com/github/phrase/phrase.png)](https://codeclimate.com/github/phrase/phrase)
[![Build Status](https://secure.travis-ci.org/phrase/phrase.png)](http://travis-ci.org/phrase/phrase)

PhraseApp is a translation management software. Set up a professional translation process to boost the quality of your translations with our powerful In-Context Editor or simply share and edit locale files with your team.

You can order professional translations through PhraseApp or work with your own translators. Our platform supports various programming languages and frameworks. Such as [Ruby on Rails, Symfony, Zend Framework, iOS, Android and many more](https://phraseapp.com/docs/general/supported-platforms).

[Try out PhraseApp for free](https://phraseapp.com/features) and start translating your app!

### In-Context Editor ###
PhraseApp comes with an In-Context editor that allows you to translate directly on your website. See our documentation on how to set it up: [In-Context Editor Setup](http://docs.phraseapp.com/guides/in-context-editor/).

### Installation

Install the gem via `gem install`

	gem install phraseapp-in-context-editor-ruby
	
or add it to your `Gemfile` when using bundler:

	gem 'phraseapp-in-context-editor-ruby'

and install it	

	$ bundle install
	
That's it!

### Initialization

Install phrase by executing the Rails generator:

	bundle exec rails generate phrase:install --auth-token=<YOUR_TOKEN>
	
This will:

* create a `phrase.rb` initializer file in `./config/initializers/`
* initialize your phrase project by creating a default locale in PhraseApp
* create a `.phrase` configuration file containing the secret

*Using the generator will automatically prepare your Rails application for use with the [In-Context-Editor](https://phraseapp.com/features).*

## Further Information
* [Read the PhraseApp Documentation](http://docs.phraseapp.com/)
* [Software Translation Managemeny with PhraseApp](https://phraseapp.com/features)
* [Get in touch with PhraseApp Team](https://phraseapp.com/contact)

## References
* [PhraseApp API Documentation](http://docs.phraseapp.com/api/v1/)
* [Demo of the In-Context Editor](http://demo.phraseapp.com)
* [Localization Guides and Software Translation Best Practices](http://localize-software.phraseapp.com/)

## Partner-Integrations
* [Integrate PhraseApp with Ruby Motion](https://github.com/phrase/motion-phrase)
* [Integrate PhraseApp as a Heroku Add-on](https://addons.heroku.com/phrase)
* [Integrate PhraseApp as a Cloudcontrol Add-on](https://phraseapp.com/docs/cloudcontrol/introduction)
