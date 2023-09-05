PhraseApp::InContextEditor.configure do |config|
  # Enable or disable the In-Context-Editor in general
  config.enabled = true

  # Fetch your project id after creating your first project
  # in Translation Center.
  # You can find the project id in your project settings
  # page (https://phraseapp.com/projects)
  config.project_id = "00000000000000004158e0858d2fa45c"
  config.account_id = "0bed59e5"
  config.datacenter = "eu"

  # PhraseApp uses decorators to generate a unique identification key
  # in context of your document. However, this might result in conflicts
  # with other libraries (e.g. client-side template engines) that use a similar syntax.
  # If you encounter this problem, you might want to change this decorator pattern.
  # More information: https://help.phraseapp.com/phraseapp-for-developers/how-to-setup-and-configure-the-phraseapp-in-context-editor-ice/configure-in-context-editor
  # config.prefix = "[[__"
  # config.suffix = "__]]"
end
