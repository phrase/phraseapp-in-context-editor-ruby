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

  config.before(:each) do
    PhraseApp::InContextEditor.stub(:access_token).and_return("5c957b9ecd8db363b378806d2062c6289df379d6e333f37386f680270b108cf1")
    PhraseApp::InContextEditor.stub(:project_id).and_return("49463eeb0470aadbd3816d4755e9f5ed")
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
