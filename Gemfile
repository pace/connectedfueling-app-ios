source "https://rubygems.org"

gem "fastlane", git: 'https://github.com/jttoddy/fastlane', branch: 'pilot-app-clips'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
