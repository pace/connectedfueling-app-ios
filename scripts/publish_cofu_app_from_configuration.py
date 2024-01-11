import os
import argparse
import json
import subprocess

parser = argparse.ArgumentParser(description='Publishes app from configuration')
parser.add_argument('--configuration-directory', action='store', help='Directory containing configuration files', required=True)
args = parser.parse_args()

configuration = {}

def publish_cofu_app_from_configuration():
  load_configuration_from_file()
  publish_app()

def load_configuration_from_file():
  global configuration

  for file in os.listdir(args.configuration_directory):
    path = os.path.join(args.configuration_directory, file)

    if file == 'configuration.json':
      with open(path) as json_file:
        configuration = json.load(json_file)
        print("✅ Successfully loaded configuration from file")

def publish_app():
  test_groups = configuration.get('ios_app_review_test_groups') or []
  
  cwd = os.getcwd()
  os.chdir('..')
  
  subprocess.run([
    'bundle', 
    'exec', 
    'fastlane', 
    'publish_cofu_app_from_configuration',
    f"team_id:{configuration['ios_team_id']}",
    f"app_identifier:{configuration['application_id_ios']}",
    f"test_groups:{test_groups}",
    f"whats_new:\"$(git log $(git describe --abbrev=0 --tags $(git rev-list --tags --max-count=2))..@ --no-merges --pretty=format:"%s" -- . | while read line; do echo "- $line"; done)\""
  ])
  
  os.chdir(cwd)
  print("✅ Successfully trigger publishing of app")

print("🚀 Start publishing app from configuration")
publish_cofu_app_from_configuration()
print("🏁 Successfully completed publishing app from configuration")