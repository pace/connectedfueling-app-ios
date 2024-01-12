import os
import argparse
import json
import subprocess
import shutil
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
    ('onboarding_header_image_ios.pdf', 'Onboarding/onboarding_primary_header_icon.imageset/onboarding_header.pdf'),
    ('list_header_image_ios.pdf', 'GasStationList/gas_station_list_primary_header_icon.imageset/gas_station_list_header.pdf'),
    ('fallback_header_image_ios.pdf', 'Miscellaneous/secondary_header_icon.imageset/secondary_header.pdf'),
    ('detail_view_brand_icon_ios.pdf', 'Detail/brand_icon.imageset/brand_icon.pdf')
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
  google_services_plist_path = "../App/Resources/GoogleService-Info.plist"

  if analytics_enabled is False and crashlytics_enabled is False:
    os.remove(google_services_plist_path) 
    print("✅ Analytics and Crashlytics are disabled. Successfully removed google services file") 
  else:
    os.replace(get_asset_path('firebase_config_ios.plist'), google_services_plist_path)
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

  legal_documents = ['imprint', 'privacy_statement', 'usage_terms', 'usage_analysis']

  for language in languages:
    for document in legal_documents:
      asset_name = f"{document}_{language[1]}.html"
      asset_input_path = get_asset_path(asset_name)
      asset_output_path = f"../App/Resources/Legal/{language[0]}.lproj/{document}.html"
      
      if os.path.exists(asset_input_path):
        shutil.copyfile(asset_input_path, asset_output_path)
      else:
        print(f"⚠️ Document {asset_name} does not exist. Falling back to use English document")

        fallback_asset_name = f"{document}_en-US.html"
        fallback_asset_input_path = get_asset_path(fallback_asset_name)

        if os.path.exists(fallback_asset_input_path):
          shutil.copyfile(fallback_asset_input_path, asset_output_path)
        else:
          print(f"‼️ Error occurred while falling back to English document: File {fallback_asset_name} does not exist.")
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
    'menu_entries'
  ]

  runtimeConfig = {}

  for key in keys:
    if configuration.get(key) is not None:
      runtimeConfig[key] = configuration.get(key)

  runtimeConfig['onboarding_style'] = 'primary' if os.path.exists(get_asset_path('onboarding_header_image_ios.pdf')) else 'secondary'
  runtimeConfig['gas_station_list_style'] = 'primary' if os.path.exists(get_asset_path('list_header_image_ios.pdf')) else 'secondary'
  runtimeConfig['detail_view_style'] = 'primary' if os.path.exists(get_asset_path('detail_view_brand_icon_ios.pdf')) else 'secondary'

  with open("../App/Resources/configuration.json", 'w+') as file:
    json.dump(runtimeConfig, file, ensure_ascii=False, indent=4)
    print("✅ Successfully replaced app runtime configuration")

def get_asset_path(file_name):
  path = f"{assets_path}/{file_name}"
  return path

def configure_build_settings():
  sentry_dsn = configuration.get('sentry_dsn_ios') or ""
  idp_hint = configuration.get('default_idp') or ""

  cwd = os.getcwd()
  os.chdir('..')
  
  subprocess.run([
    'bundle', 
    'exec', 
    'fastlane', 
    'configure_build_settings',
    f"app_name:{configuration['app_name']}",
    f"app_identifier:{configuration['application_id_ios']}",
    f"analytics_enabled:{configuration['analytics_enabled']}",
    f"crashlytics_enabled:{configuration['crashlytics_enabled']}",
    f"sentry_enabled:{configuration['sentry_enabled']}",
    f"sentry_dsn:{sentry_dsn}",
    f"client_id:{configuration['client_id']}",
    f"idp_hint:{idp_hint}"
  ])
  
  os.chdir(cwd)
  print("✅ Successfully configured build settings")

def build_app():
  sentry_project_name = configuration.get('sentry_project_name_ios') or ""
  
  cwd = os.getcwd()
  os.chdir('..')
  
  subprocess.run([
    'bundle', 
    'exec', 
    'fastlane', 
    'build_cofu_app_from_configuration',
    f"team_id:{configuration['ios_team_id']}",
    f"app_identifier:{configuration['application_id_ios']}",
    f"keychain_password:{configuration['ios_keychain_password']}",
    f"sentry_enabled:{configuration['sentry_enabled']}",
    f"sentry_project_name:{sentry_project_name}"
  ])
  
  os.chdir(cwd)

print("🚀 Start building app from configuration")
build_cofu_app_from_configuration()
print("🏁 Successfully finished building app from configuration")