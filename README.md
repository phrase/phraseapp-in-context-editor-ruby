# phraseapp-in-context-editor-ruby

![Build status](https://github.com/phrase/phraseapp-in-context-editor-ruby/workflows/Test/badge.svg)

**phraseapp-in-context-editor-ruby** is the official library for integrating [Phrase Strings In-Context Editor](https://support.phrase.com/hc/en-us/articles/5784095916188-In-Context-Editor-Strings) with [i18n](https://github.com/ruby-i18n/i18n) in your Ruby application.

## :scroll: Documentation

### Prerequisites

To use phraseapp-in-context-editor-ruby with your application you have to:

- Sign up for a Phrase account: [https://app.phrase.com/signup](https://app.phrase.com/signup)
- Use the excellent [i18n](https://github.com/ruby-i18n/i18n) gem also used by [Rails](https://guides.rubyonrails.org/i18n.html)

### Demo

You can find a demo project in the `examples/demo` folder, just run `bundle && rails s` and head to `http://127.0.0.1:3000`
Login via the demo credentials `demo@phrase.com` / `phrase`

### Installation

#### NOTE: You can not use the old version of the ICE with integration versions of >2.0.0, you have to instead use 1.x.x versions as before

#### via Gem

```bash
gem install phraseapp-in-context-editor-ruby
```

#### via Bundler

Add it to your `Gemfile`

```
gem 'phraseapp-in-context-editor-ruby
```

#### Build from source

You can also build it directly from source to get the latest and greatest:

```bash
bundle && gem build
```

#### Initialized config file

Create the initializer file by executing the Rails generator:

```bash
rails generate phraseapp_in_context_editor:install --account_id=<YOUR_ACCOUNT_ID> --project-id=<YOUR_PROJECT_ID>
```

### Development

```bash
# install deps
bundle
```

#### Configure

Add the following Ruby snippet to your rails `app/views//layouts/application.html.erb`

```
<%= load_in_context_editor %>
```

And the following config to your `/config/initializers/phraseapp_in_context_editor.rb`

```ruby
  config.enabled = true
  config.project_id = "YOUR_PROJECT_ID"
  config.account_id = "YOUR_ACCOUNT_ID"
  config.datacenter = "eu"
```

You can find the Project-ID in the Project overview in the PhraseApp Translation Center.
You can find the Account-ID in the Organization page in the PhraseApp Translation Center.

If this does not work for you, you can also integrate the [JavaScript snippet manually](https://help.phrase.com/help/integrate-in-context-editor-into-any-web-framework).

Old version of the ICE is not available since version 2.0.0. If you still would rather use the old version, please go back to 1.x.x versions.

#### Using the US Datacenter with ICE

In addition to the settings in your `config/initializers/phraseapp_in_context_editor.rb`, set the US datacenter to enable the ICE to work with the US endpoints.

```ruby
  config.enabled = true
  config.project_id = "YOUR_PROJECT_ID"
  config.account_id = "YOUR_ACCOUNT_ID"
  config.datacenter = "us"
```

#### Using with CSP

The script will automatically get the nonce from `content_security_policy_nonce`
The content_security_policy.rb has to have `:strict_dynamic` for `policy.script_src` and `:unsafe_inline` for `policy.style_src`

```ruby
  policy.script_src :self, :https, :strict_dynamic
  policy.style_src :self, :https, :unsafe_inline
```

The `config.content_security_policy_nonce_directives = %w[script-src style-src]` can include `style-src` but this _might_ break some styling in some cases

### Browser support

This library might not work out of the box for some older browser or IE11. We recommend to add [Babel](https://github.com/babel/babel) to the build pipeline if those browser need to be supported.

### How does it work

The library adds custom functionality to the `i18n` package. When `config.enabled = true` this gem modifies the outcoming values from translation functions to present a format which the ICE can read.

### Test

Run unit tests using jest:

```bash
rspec
```

## :white_check_mark: Commits & Pull Requests

We welcome anyone who wants to contribute to our codebase, so if you notice something, feel free to open a Pull Request! However, we ask that you please use the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification for your commit messages and titles when opening a Pull Request.

Example: `chore: Update README`

## :question: Issues, Questions, Support

Please use [GitHub issues](https://github.com/phrase/phraseapp-in-context-editor-ruby/issues) to share your problem, and we will do our best to answer any questions or to support you in finding a solution.

## :memo: Changelog

Detailed changes for each release are documented in the [changelog](https://github.com/phrase/phraseapp-in-context-editor-ruby/releases).
