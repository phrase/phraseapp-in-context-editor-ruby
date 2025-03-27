require "rspec"
require "rails/engine"
require "rails/generators"
require "simplecov"
require "simplecov_json_formatter"

require "phraseapp-in-context-editor-ruby"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.after(:each) do |example|
    PhraseApp::InContextEditor::Config.reset_to_defaults!
    RequestStore.store[:phraseapp_config] = nil
  end
end

SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start
