module InContextEditor::ViewHelpers
  def phraseapp_javascript
    return "" unless InContextEditor.enabled?

    js = <<-eos
            <script>
              window.PHRASEAPP_CONFIG = {
                    projectId: '#{InContextEditor.project_id}'
                  };
              (function() {
                var phraseapp = document.createElement('script'); phraseapp.type = 'text/javascript'; phraseapp.async = true;
                phraseapp.src = ['#{InContextEditor.js_use_ssl ? 'https' : 'http'}://', '#{InContextEditor.js_host}/dev-assets/in-context-editor/2.0/app.js?', new Date().getTime()].join('');
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(phraseapp, s);
              })();
            </script>
         eos
    js.respond_to?(:html_safe) ? js.html_safe : js
  end
end