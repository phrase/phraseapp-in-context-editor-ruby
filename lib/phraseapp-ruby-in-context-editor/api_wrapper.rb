require 'phraseapp-ruby-in-context-editor/api_collection'

class InContextEditor::ApiWrapper

  def initialize
    @api_client = InContextEditor.api_client
  end

  def default_locale
    @default_locale ||= select_default_locale 
  end

  def default_translation(key)
    params = PhraseApp::TranslationsByKeyParams.new
    translations = InContextEditor::ApiCollection.new(@api_client, "translations_by_key", project_and_key_id(key), params).collection
    return unless translations.present?

    translations.select{ |translation| translation.locale["id"] == default_locale.id }
  end

  def keys_with_prefix(prefix)
    params = PhraseApp::KeysListParams.new(q:"#{prefix}*")
    keys_list(params)
  end

  def keys_by_names(names)
    names = names.join(',')
    params = PhraseApp::KeysListParams.new(:q => "name:#{names}")
    keys_list(params)
  end

  def keys_list(params)
    InContextEditor::ApiCollection.new(@api_client, "keys_list", project_id, params).collection
  end

  def blacklisted_keys
    InContextEditor::ApiCollection.new(@api_client, "exclude_rules_index", project_id).collection.map{ |rule| rule.name }
  end

  private

  def select_default_locale
    locales = InContextEditor::ApiCollection.new(@api_client, "locales_list", project_id).collection
    return unless locales.present?

    locales.select{ |loc| loc.default }.first
  end

  def project_id
    [InContextEditor.project_id]
  end

  def project_and_key_id(key)
    project_id << key.id
  end
end
