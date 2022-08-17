# Phrase In-Context Editor for Ruby #

*This Ruby gem is for use with Ruby (Rails, Sinatra) applications only. Check out the [documentation](https://help.phrase.com/help/translate-directly-on-your-website) to learn how to set up the In-Context Editor with other technologies.*

![Build Status](https://github.com/phrase/phraseapp-in-context-editor-ruby/workflows/Test/badge.svg)

Phrase is the translation management solution for web and mobile applications. Collaborate with your team, find professional translators and stay on top of the process.

[Try out Phrase for free](https://phrase.com/signup) and start translating your app!

*Note: This gem  [documentation](https://help.phrase.com/help/translate-directly-on-your-website) to learn how to install the In-Context Editor with other technologies.*

## In-Context-Editor ###

How awesome would it be if translators could simply browse your website and edit text along the way? Our In-Context Editor offers just that. It provides translators with useful contextual information which improves overall translation quality. See our documentation on how to set it up: [In-Context Editor Setup](https://help.phrase.com/help/translate-directly-on-your-website).

## Installation

### Install the gem

Install the gem via `gem install`:

    gem install phraseapp-in-context-editor-ruby

or add it to your `Gemfile` when using bundler:

    gem 'phraseapp-in-context-editor-ruby'

and install it:

    $ bundle install

Next, create the initializer file by executing the Rails generator:

    $ bundle exec rails generate phraseapp_in_context_editor:install --access-token=<YOUR_TOKEN> --project-id=<YOUR_PROJECT_ID>

##### --access-token

You can create and manage access tokens in your [profile settings](https://app.phrase.com/settings/oauth_access_tokens) or via the [Authorizations API](https://developers.phrase.com/api/#authorizations).

##### --project-id

You can find the ID of your project in your project settings in Translation Center.

### Add the JavaScript helper

Next, add the Javascript helper to your Rails application layout file:

    <%= phraseapp_in_context_editor_js %>

If you don't want to use the helper but add the plain Javascript yourself, head over to our [documentation](https://help.phrase.com/help/translate-directly-on-your-website) to learn more.

### Done!

Restart your application to see the In-Context Editor in action!

### Using US datacenter

In the generated `phraseapp_in_context_editor.rb` add these options to enable connecting to the US datacenter.
```
  config.api_host = 'https://api.us.app.phrase.com'
  config.js_options = {
    baseUrl: 'https://us.app.phrase.com',
    profileUrl: 'https://us.app.phrase.com/settings/profile'
  }
```

### OpenSSL issues

Please note that outdated certificates or old versions of OpenSSL may cause connection issues, especially on Mac OSX. We recommend using Ruby 2.2.2 with OpenSSL 1.0.2d or later. If you experience OpenSSL-related errors, try the following.

Upgrade OpenSSL using Homebrew:

```shell
$ brew upgrade openssl
$ brew install openssl
```

If you are using RVM, also run:

```shell
$ rvm osx-ssl-certs status all
$ rvm osx-ssl-certs update all
````

As a workaround, you can disable SSL certificate verification in your `config/initializers/phraseapp_in_context_editor.rb` by adding the following line:

```ruby
  config.skip_ssl_verification = true
```

This is **not recommended** and should only be used as a temporary workaround.


## Further Information
* [Phrase Help Center](https://help.phrase.com/)
* [Software Translation Management with Phrase](https://phrase.com/features)
* [Contact us](https://phrase.com/contact)

## References
* [Phrase API Documentation](https://developers.phrase.com/api/)
* [In-Context-Editor Demo](https://phrase.com/demo)
* [Localization Guides and Software Translation Best Practices](https://phrase.com/blog/)

## Get help / support

Please contact [support@phrase.com](mailto:support@phrase.com?subject=[GitHub]%20) and we can take more direct action toward finding a solution.
