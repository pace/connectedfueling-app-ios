if which swiftlint > /dev/null; then
    swiftlint --quiet --config .swiftlint.yml
else
    echo "warning: SwiftLint not installed, download it from https://github.com/realm/SwiftLint"
fi

