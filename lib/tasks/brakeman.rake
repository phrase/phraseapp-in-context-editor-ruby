require "json"
namespace :brakeman do
  desc "Starts static code anaylsis with brakeman and output as json"
  task :sonarqube do
    rails_app_path = ENV.fetch("RAILS_APP_PATH", "../phrase")
    brakeman_output = `bundle exec brakeman #{rails_app_path} --format json --quiet`
    raise "Brakeman scan failed!" if brakeman_output.strip.empty?

    json = JSON.parse(brakeman_output)

    severity = Hash.new("INFO").merge!(
      "High" => "CRITICAL",
      "Medium" => "MAJOR",
      "Weak" => "MINOR"
    )

    output = json["warnings"].each_with_object("issues" => []) { |warning, memo|
      memo["issues"] << {
        "engineId" => "brakeman",
        "ruleId" => warning["fingerprint"],
        "type" => "VULNERABILITY",
        "severity" => severity[warning["confidence"]],
        "primaryLocation" => {
          "message" => "#{warning["warning_type"]} - #{warning["check_name"]} - #{warning["message"]}",
          "filePath" => warning["file"],
          "textRange" => {
            "startLine" => warning["line"]
          }
        }
      }
    }.to_json
    File.write("sonarqube.json", output)
  end
end
