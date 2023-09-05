require "json"

module PhraseApp
  module InContextEditor
    module ViewHelpers
      def load_in_context_editor(opts = {})
        return "" unless PhraseApp::InContextEditor.enabled?

        # stringify to reduce possible errors when passing symbols
        opts = opts.nil? ? {} : opts.each_with_object({}) { |(k, v), conf|
                                  conf[k.to_s] = v
                                }

        # js options
        configuration = {
          "projectId" => PhraseApp::InContextEditor.project_id,
          "accountId" => PhraseApp::InContextEditor.account_id,
          "datacenter" => PhraseApp::InContextEditor.datacenter,
          "prefix" => PhraseApp::InContextEditor.prefix,
          "suffix" => PhraseApp::InContextEditor.suffix
        }.merge(opts)

        snippet = <<-EOS
        <script>
          window.PHRASEAPP_CONFIG = #{configuration.to_json};
          (function() {
            let phraseapp = document.createElement('script');
            phraseapp.type = 'module';
            phraseapp.async = true;
            phraseapp.src = "https://d2bgdldl6xit7z.cloudfront.net/latest/ice/index.js";
            let script = document.getElementsByTagName('script')[0];
            script.parentNode.insertBefore(phraseapp, script);
          })();
        </script>
        EOS
        snippet.respond_to?(:html_safe) ? snippet.html_safe : snippet
      end
      alias_method :phraseapp_in_context_editor_js, :load_in_context_editor
    end
  end
end
