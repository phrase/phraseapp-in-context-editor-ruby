require 'json'

module PhraseApp
  module InContextEditor
    module ViewHelpers
      def phraseapp_in_context_editor_js(opts={})
        return "" unless PhraseApp::InContextEditor.enabled?

        # stringify to reduce possible errors when passing symbols
        js_default_options = PhraseApp::InContextEditor.js_options.inject({}) { |conf, (k,v)| conf[k.to_s] = v; conf}
        opts = opts.nil? ? {} : opts.inject({}) { |conf, (k,v)| conf[k.to_s] = v; conf}

        # js options
        configuration = {
          'projectId' => PhraseApp::InContextEditor.project_id,
          'prefix' => PhraseApp::InContextEditor.prefix,
          'suffix' => PhraseApp::InContextEditor.suffix,
          'apiBaseUrl' => "#{PhraseApp::InContextEditor.api_host}/api/v2",
        }.merge(js_default_options).merge(opts)

        snippet = <<-eos
          <script>
            window.PHRASEAPP_CONFIG = #{configuration.to_json};
            (function() {
              var phraseapp = document.createElement('script'); phraseapp.type = 'text/javascript'; phraseapp.async = true;
              phraseapp.src = ['#{PhraseApp::InContextEditor.js_use_ssl ? 'https' : 'http'}://', '#{PhraseApp::InContextEditor.js_host}#{PhraseApp::InContextEditor.js_path}?', new Date().getTime()].join('');
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(phraseapp, s);
            })();
          </script>
        eos
        snippet.respond_to?(:html_safe) ? snippet.html_safe : snippet
      end
    end
  end
end
