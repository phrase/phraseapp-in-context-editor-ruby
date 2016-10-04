require 'rspec'
require 'vcr'
require 'timecop'
require 'webmock/rspec'
require 'rails/engine'
require 'rails/generators'

require 'phraseapp-in-context-editor-ruby'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    Timecop.return
  end

  config.before(:each) do |example|
    if example.metadata[:vcr]
      PhraseApp::InContextEditor::Config.access_token = "5c957b9ecd8db363b378806d2062c6289df379d6e333f37386f680270b108cf1"
      PhraseApp::InContextEditor::Config.project_id = "49463eeb0470aadbd3816d4755e9f5ed"
    end
  end

  config.after(:each) do |example|
    PhraseApp::InContextEditor::Config.reset_to_defaults!
    Thread.current[:phraseapp_config] = nil
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
