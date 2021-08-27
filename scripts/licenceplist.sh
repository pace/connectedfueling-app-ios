if which license-plist > /dev/null; then
    if [ $CONFIGURATION = "Development" ]; then
        license-plist --output-path $PRODUCT_NAME/SupportingFiles/Settings.bundle --package-path $PROJECT_FILE_PATH/project.xcworkspace/xcshareddata/swiftpm/Package.swift --add-version-numbers --fail-if-missing-license 
    fi
else
    echo "warning: license-plist not installed, follow installation instructions from https://github.com/mono0926/LicensePlist"
fi

