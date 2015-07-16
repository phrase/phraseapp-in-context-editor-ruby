# PhraseApp In-Context-Editor #

[![Build Status](https://secure.travis-ci.org/phrase/phraseapp-in-context-editor-ruby.png)](http://travis-ci.org/phrase/phraseapp-in-context-editor-ruby)

PhraseApp is the translation management solution for web and mobile applications. Collaborate with your team, find professional translators and stay on top of the process.

[Try out Phraseapp for free](https://phraseapp.com/signup) and start translating your app!

### In-Context-Editor ###

How awesome would it be if translators could simply browse your website and edit text along the way? Our In-Context Editor offers just that. It provides translators with useful contextual information which improves overall translation quality. See our documentation on how to set it up: [In-Context Editor Setup](http://docs.phraseapp.com/guides/in-context-editor/).

### Installation

Install the gem via `gem install`:

    gem install phraseapp-in-context-editor-ruby

or add it to your `Gemfile` when using bundler:

    gem 'phraseapp-in-context-editor-ruby'

and install it:

    $ bundle install

Next, create the initializer file by executing the Rails generator:

    $ bundle exec rails generate phraseapp-in-context-editor-ruby:install --access-token=<YOUR_TOKEN> --project-id=<YOUR_PROJECT_ID>

#### --access-token

You can create and manage access tokens in your [profile settings](https://phraseapp.com/settings/profile/oauth_access_tokens) or via the [Authorizations API](http://docs.phraseapp.com/api/v2/authorizations).

#### --project-id

You can find the ID of your project in your project settings in Translation Center.

Next, add the Javascript helper to your Rails application layout file:

    <%= phraseapp_in_context_editor_js %>

Restart your application to see the In-Context-Editor in action!

## Further Information
* [Read the PhraseApp Documentation](http://docs.phraseapp.com/)
* [Software Translation Management with PhraseApp](https://phraseapp.com/features)
* [Contact us](https://phraseapp.com/contact)

## References
* [PhraseApp API Documentation](http://docs.phraseapp.com/api/v2/)
* [In-Context-Editor Demo](http://demo.phraseapp.com)
* [Localization Guides and Software Translation Best Practices](http://localize-software.phraseapp.com/)
