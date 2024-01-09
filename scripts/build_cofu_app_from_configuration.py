import os
import argparse
import json
import subprocess
from sys import exit

parser = argparse.ArgumentParser(description='Builds app from configuration')
parser.add_argument('--configuration-directory', action='store', help='Directory containing configuration files', required=True)
args = parser.parse_args()

configuration = {}
assets_path = ""

def build_cofu_app_from_configuration():
  load_configuration_from_file()
  replace_images()
  replace_keychain()
  replace_google_services()
  replace_legal_documents()
  replace_runtime_configuration()
  configure_build_settings()
  build_app()

def load_configuration_from_file():
  global configuration
  global assets_path

  for file in os.listdir(args.configuration_directory):
    path = os.path.join(args.configuration_directory, file)
    print(path)

    if os.path.isdir(path) and file == 'assets':
      assets_path = path
      print("✅ Successfully retrieved assets folder")
    elif file == 'configuration.json':
      with open(path) as json_file:
        configuration = json.load(json_file)
        print("✅ Successfully loaded configuration from file")

def replace_images():
  app_icon = 'ios_icon.png'

  images = [
    (app_icon, 'AppIcon.appiconset/Icon.png'),
    ('ios_onboarding_header_image.pdf', 'Onboarding/onboarding_primary_header_icon.imageset/onboarding_header.pdf'),
    ('ios_list_header_image.pdf', 'GasStationList/gas_station_list_primary_header_icon.imageset/gas_station_list_header.pdf'),
    ('ios_fallback_header_image.pdf', 'Miscellaneous/secondary_header_icon.imageset/secondary_header.pdf'),
    ('ios_detail_view_brand_icon.pdf', 'Detail/brand_icon.imageset/brand_icon.pdf')
  ]

  for image in images:
    image_name = image[0]
    image_input_path = get_asset_path(image_name)
    image_output_path = image[1]

    if os.path.exists(image_input_path):
      os.replace(image_input_path, f"../App/Resources/Images.xcassets/{image_output_path}")
    elif image_name == app_icon:
      print(f"‼️ Error occurred while replacing {image_name}. File does not exist.")
      exit(1)
    else:
      print(f"⚠️ Error occurred while replacing {image_name}. File does not exist. This might be intentional.")

  print(f"✅ Successfully replaced images") 

def replace_keychain():
  os.replace(get_asset_path('ios_keychain.keychain'), "../App/Resources/keychain.keychain")
  print("✅ Successfully replaced keychain")

def replace_google_services():
  analytics_enabled = configuration['analytics_enabled']
  crashlytics_enabled = configuration['crashlytics_enabled']

  if analytics_enabled is False and crashlytics_enabled is False:
    os.remove("../App/Resources/GoogleService-Info.plist") 
    print("✅ Analytics and Crashlytics are disabled. Successfully removed google services file") 
  else:
    os.replace(get_asset_path('firebase_ios.keychain'), "../App/Resources/GoogleService-Info.plist")
    print("✅ Successfully replaced google services file")

def replace_legal_documents():
  # Create tuple of supported languages in project and the ones in Directus
  languages = [
    ('cs', 'en-US'),
    ('da', 'en-US'),
    ('de', 'de-DE'),
    ('en', 'en-US'),
    ('es', 'en-US'),
    ('fr', 'fr-FR'),
    ('it', 'en-US'),
    ('nl', 'en-US'),
    ('pl', 'en-US'),
    ('pt', 'en-US'),
    ('ro', 'en-US'),
    ('ru', 'en-US')
  ]

  legal_documents = ['imprint', 'privacy', 'terms', 'analytics']

  for language in languages:
    for document in legal_documents:
      asset_name = f"{document}_{language[1]}.html"
      asset_input_path = get_asset_path(asset_name)
      asset_output_path = f"../App/Resources/Legal/{language[0]}.lproj/{document}.html"
      
      if os.path.exists(asset_input_path):
        os.replace(asset_input_path, asset_output_path)
      else:
        print("⚠️ Document does not exist. Falling back to use English document")

        fallback_asset_name = f"{document}_en-US.html"
        fallback_asset_input_path = get_asset_path(asset_name)

        if os.path.exists(fallback_asset_input_path):
          os.replace(fallback_asset_input_path, asset_output_path)
        else:
          print("‼️ Error occurred while falling back to English document: File does not exist.")
          exit(1)
  
  print("✅ Successfully replaced legal documents")

def replace_runtime_configuration():
  keys = [
    'client_id', 
    'primary_branding_color', 
    'secondary_branding_color',
    'analytics_enabled',
    'native_fuelcard_management_enabled',
    'map_enabled',
    'vehicle_integration_enabled',
    'hide_prices',
    'menu_entry'
  ]

  onboarding_header_image_key = 'onboarding_header_image'
  list_header_image_key = 'list_header_image'

  runtimeConfig = {}

  for key in keys:
    if key in configuration and configuration[key] is not None:
      runtimeConfig[key] = configuration[key]

  runtimeConfig['onboarding_style'] = os.path.exists(get_asset_path('onboarding_header_image')) ? 'primary' : 'secondary'
  runtimeConfig['gas_station_list_style'] = os.path.exists(get_asset_path('list_header_image')) ? 'primary' : 'secondary'

  with open("../App/Resources/configuration.json", 'w+') as file:
    json.dump(runtimeConfig, file, ensure_ascii=False, indent=4)
    print("✅ Successfully replaced app runtime configuration")

def get_asset_path(file_name):
  path = f"{assets_path}/{file_name}"
  return path

def configure_build_settings():
  cwd = os.getcwd()
  os.chdir('..')
  
  subprocess.run([
    'bundle', 
    'exec', 
    'fastlane', 
    'configure_build_settings',
    f"app_name:{configuration['app_name']}",
    f"app_identifier:{configuration['application_id']}",
    f"analytics_enabled:{configuration['analytics_enabled']}",
    f"crashlytics_enabled:{configuration['crashlytics_enabled']}",
    f"sentry_enabled:{configuration['sentry_enabled']}",
    f"sentry_dsn:{configuration['sentry_dsn']}",
    f"client_id:{configuration['client_id']}",
    f"idp_hint:{configuration['idp_hint']}"
  ])
  
  os.chdir(cwd)
  print("✅ Successfully configured build settings")

def build_app():
  cwd = os.getcwd()
  os.chdir('..')
  
  subprocess.run([
    'bundle', 
    'exec', 
    'fastlane', 
    'build_cofu_app_from_configuration',
    f"team_id:{configuration['team_id']}",
    f"app_identifier:{configuration['application_id']}",
  ])
  
  os.chdir(cwd)
  print("✅ Successfully built app")

print("🚀 Start building app from configuration")
build_cofu_app_from_configuration()
print("🏁 Successfully finished app configuration")