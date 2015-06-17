InContextEditor.configure do |config|
  # Enable or disable the Phraseapp context editor in general
  config.enabled = true

  # Fetch your project id after creating your first project
  # in the Phraseapp translation center. 
  # You can find the project id in your projects settings
  # page (https://phraseapp.com/projects/<your_project>/edit)
  config.project_id = "<%= options[:project_id] %>"

  # OAuth is preferred over Basic authentication because OAuth tokens
  # can be limited to specific scopes, and can be revoked by users at any time.
  # You can create and manage OAuth access tokens in your profile settings
  # (https://phraseapp.com/me/oauth_access_tokens) in Translation Center or
  # via the Authorizations API (http://docs.phraseapp.com/api/v2/authorizations/).
  config.access_token = "<%= options[:access_token] %>"


  # Configure an array of key names that should not be handled
  # with Phraseapp. This is useful when a key causes problems
  # (Such as keys that are used by Rails internally)
  config.ignored_keys = ["number.*", "breadcrumb.*"]

  # Phraseapp uses decorators to generate a unique identification key
  # in context of your document. However, this might result in conflicts
  # with other libraries (e.g. client-side template engines) that use a similar syntax.
  # If you encounter this problem, you might want to change the phrase decorator.
  # More information: https://phraseapp.com/docs/installation/phrase-gem
  # config.prefix = "{{__"
  # config.suffix = "__}}"
end
