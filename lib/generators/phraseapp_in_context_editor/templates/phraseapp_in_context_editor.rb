PhraseApp::InContextEditor.configure do |config|
  # Enable or disable the In-Context-Editor in general
  config.enabled = true

  # Fetch your project id after creating your first project
  # in Translation Center.
  # You can find the project id in your project settings
  # page (https://phraseapp.com/projects)
  config.project_id = "<%= options[:project_id] %>"

  # You can create and manage access tokens in your profile settings
  # in Translation Center or via the Authorizations API
  # (https://developers.phraseapp.com/api/#authorizations).
  config.access_token = "<%= options[:access_token] %>"

  # Configure an array of key names that should not be handled
  # by the In-Context-Editor.
  config.ignored_keys = ["number.*", "breadcrumb.*"]

  # PhraseApp uses decorators to generate a unique identification key
  # in context of your document. However, this might result in conflicts
  # with other libraries (e.g. client-side template engines) that use a similar syntax.
  # If you encounter this problem, you might want to change this decorator pattern.
  # More information: https://help.phraseapp.com/phraseapp-for-developers/how-to-setup-and-configure-the-phraseapp-in-context-editor-ice/configure-in-context-editor
  # config.prefix = "{{__"
  # config.suffix = "__}}"
end
