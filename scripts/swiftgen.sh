if which swiftgen > /dev/null; then
    swiftgen config run --config swiftgen.yml
else
    echo "warning: SwiftGen not installed, download it from https://github.com/SwiftGen/SwiftGen"
fi

