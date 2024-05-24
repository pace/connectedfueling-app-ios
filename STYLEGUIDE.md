# Style Guide

## Table Of Contents

- [Style Guide](#style-guide)
  - [Table Of Contents](#table-of-contents)
  - [Source File Basics \& Structure](#source-file-basics--structure)
    - [File Names](#file-names)
    - [File Headers](#file-headers)
    - [Import Statements](#import-statements)
    - [Type, Variable and Function Declarations](#type-variable-and-function-declarations)
    - [Extensions](#extensions)
  - [Formatting](#formatting)
    - [Line Length](#line-length)
    - [Braces](#braces)
    - [Semicolons](#semicolons)
    - [One Statement Per Line](#one-statement-per-line)
    - [Parentheses](#parentheses)
    - [Switch Statements](#switch-statements)
    - [Enum Cases](#enum-cases)
    - [Numeric Literals](#numeric-literals)
  - [Naming](#naming)
    - [Naming Conventions Are Not Access Control](#naming-conventions-are-not-access-control)
    - [Global Constants](#global-constants)
  - [Programming Practices](#programming-practices)
    - [Compiler Warnings](#compiler-warnings)
    - [Properties](#properties)
    - [Optional Types](#optional-types)
    - [Force Unwrapping and Force Casts](#force-unwrapping-and-force-casts)
    - [Implicitly Unwrapped Optionals](#implicitly-unwrapped-optionals)
    - [Nesting and Namespacing](#nesting-and-namespacing)
    - [`guards` for Early Exits](#guards-for-early-exits)
  - [Linting](#linting)
  - [External Dependencies](#external-dependencies)
  - [Localization](#localization)
  - [Theming](#theming)

## Source File Basics & Structure

### File Names

All Swift source files end with the extension `.swift`.

In general, the name of a source file best describes the primary entity that it contains. A file that primarily contains a single type has the name of that type. A file that extends an existing type is named with a combination of the type name and its purpose or `Extension`, joined with a plus (+) sign. For more complex situations, exercise your best judgment.

### File Headers

File headers describing the contents of a source file are discouraged, including the copyright statement.

### Import Statements

A source file imports exactly the top-level modules that it needs; nothing more and nothing less. 

It is encouraged to only import whole modules instead of individual declarations and submodules, since it's the prevailing style (based on official examples).

Import statements are the first non-comment tokens in a source file. They are ordered lexicographically.

### Type, Variable and Function Declarations

In general, most source files contain only one top-level type, especially when the type declaration is large. Exceptions are allowed when it makes sense to include multiple related types in a single file.

What is important is that each file and type uses some logical order.

When deciding on the logical order of members, it can be helpful for readers and future writers (including yourself) to use // MARK: comments to provide descriptions for that grouping.

### Extensions

Extensions can be used to organize functionality of a type across multiple "units". As with member order, the organizational structure/grouping you choose can have a great effect on readability.

## Formatting

### Line Length

Swift code has a line length limit of 180 characters as defined in the `.swiftlint.yml` file.

### Braces

- There **is no** line break before the opening brace ({).
- There **is a** line break before the closing brace (}), except where it may be omitted as described in [One Statement Per Line](#one-statement-per-line), or it completes an empty block.

### Semicolons

Semicolons (\;\) are not used, either to terminate or separate statements.

### One Statement Per Line

There is **at most** one statement per line, and each statement is followed by a line break, except when the line ends with a block that also contains zero or one statements.

Wrapping the body of a single-statement block onto its own line is always allowed. Exercise best judgment when deciding whether to place a conditional statement and its body on the same line. For example, single line conditionals work well for early-return and basic cleanup tasks, but less so when the body contains a function call with significant logic. When in doubt, write it as a multi-line statement.

```swift
guard let gasStation = gasStation else { return nil }

defer { isLoading = false }

var someProperty: Int {
  get { return otherObject.property }
  set { otherObject.property = newValue }
}
```

### Parentheses

Parentheses are not used around the top-most expression that follows an `if`, `guard`, `while`, or `switch` keyword.

```swift
// ✅

if gasStations.isEmpty {
  print("No gas stations")
}

// ❌

if (gasStations.isEmpty) {
  print("No gas stations")
}
```

### Switch Statements

Case statements are indented at the same level as the switch statement to which they belong. Include a vertical whitespace (empty line) between cases in switch statements.

```swift
switch fuelType {
case .diesel:
  print("Diesel")

case .petrol:
  print("Petrol")

case .lpg:
  print("LPG")
}
```

### Enum Cases

In general, there is only one case per line in an enum. The comma-delimited form may be used only when none of the cases have associated values or raw values, all cases fit on a single line, and the cases do not need further documentation because their meanings are obvious from their names.

```swift
// ✅

enum FuelType {
  case diesel, petrol, lpg
}

enum FuelType {
  case diesel
  case petrol
  case someOther(String)
}

// ❌

enum FuelType {
  case diesel, petrol, someOther(String)
}
```

### Numeric Literals

It is recommended but not required that long numeric literals (decimal, hexadecimal, octal, and binary) use the underscore (\_\) separator to group digits for readability when the literal has numeric value.

## Naming

### Naming Conventions Are Not Access Control

Restricted access control (`internal`, `fileprivate`, or `private`) is preferred for the purposes of hiding information from clients, rather than naming conventions.

### Global Constants

Like other variables, global constants are lowerCamelCase. Hungarian notation, such as a leading g or k, is not used.

```swift
// ✅

let gasStationsRequestRadius = 10_000

// ❌

let kGasStationsRequestRadius = 10_000
let GASSTATIONS_REQUEST_RADIUS = 10_000
```

## Programming Practices

Common themes among the rules in this section are: avoid redundancy, avoid ambiguity, and prefer implicitness over explicitness unless being explicit improves readability and/or reduces ambiguity.

### Compiler Warnings

Code should compile without warnings when feasible. Any warnings that are able to be removed easily by the author must be removed.

A reasonable exception is deprecation warnings, where it may not be possible to immediately migrate to the replacement API, or where an API may be deprecated for external users but must still be supported inside a library during a deprecation period.

### Properties

```swift
// ✅

var sum: Int {
  return prices.reduce(0, +)
}

// ❌

var sum: Int {
  get {
    return prices.reduce(0, +)
  }
}
```

### Optional Types

Sentinel values are avoided when designing algorithms (for example, an "index" of −1 when an element was not found in a collection). Sentinel values can easily and accidentally propagate through other layers of logic because the type system cannot distinguish between them and valid outcomes.

Optional is used to convey a non-error result that is either a value or the absence of a value. For example, when searching a collection for a value, not finding the value is still a **valid and expected** outcome, not an error.

```swift
// ✅

func index(of gasStation: GasStation, in gasStations: [GasStation]) -> Int? {
  // ...
}

if let index = index(of: gasStation, in: gasStations) {
  // Found it.
} else {
  // Didn't find it.
}

// ❌

func index(of gasStation: GasStation, in gasStations: [GasStation]) -> Int {
  // ...
}

let index = index(of: gasStation, in: gasStations)
if index != -1 {
  // Found it.
} else {
  // Didn't find it.
}
```

Conditional statements that test that an Optional is non-`nil` but do not access the wrapped value are written as comparisons to `nil`. The following example is clear about the programmer’s intent:

```swift
// ✅

if gasStation != nil {
  print("gasStation was not nil")
}

// ❌

if let _ = gasStation {
  print("gasStation was not nil")
}
```

### Force Unwrapping and Force Casts

Force-unwrapping and force-casting are often code smells and are strongly discouraged. Unless it is extremely clear from surrounding code why such an operation is safe, a comment should be present that describes the invariant that ensures that the operation is safe.

```swift
let fuelType = getSomeFuelType()

// ...intervening code...

// This force-unwrap is safe because `fuelType` is guaranteed to fall within the
// valid enum cases because it came from some data source that only permits
// those raw values.
return FuelType(rawValue: fuelType)!
```

### Implicitly Unwrapped Optionals

Implicitly unwrapped optionals are inherently unsafe and should be avoided whenever possible in favor of non-optional declarations or regular Optional types.

### Nesting and Namespacing

Swift allows `enums`, `structs`, and `classes` to be nested, so nesting is preferred (instead of naming conventions) to express scoped and hierarchical relationships among types when possible.

Declaring an `enum` without cases is the canonical way to define a “namespace” to group a set of related declarations, such as constants or helper functions. This `enum` automatically has no instances and does not require that extra boilerplate code be written to prevent instantiation.

```swift
// ✅

enum Constants {
  static let gasStationsRequestRadius = 10_000
}

// ❌

struct Constants {
  private init() {}
  
  static let gasStationsRequestRadius = 10_000
}
```

### `guards` for Early Exits

A `guard` statement, compared to an `if` statement with an inverted condition, provides visual emphasis that the condition being tested is a special case that causes early exit from the enclosing scope.

Furthermore, `guard` statements improve readability by eliminating extra levels of nesting; failure conditions are closely coupled to the conditions that trigger them and the main logic remains flush left within its scope.

A `guard-continue` statement can also be useful in a loop to avoid increased indentation when the entire body of the loop should only be executed in some cases.

## Linting

[Swiftlint](https://github.com/realm/SwiftLint) is used for linting in this project. The file `.swiftlint.yml` in the root directory contains all of the custom rules that are being applied during the build step.

Make sure you've installed `SwiftLint` on your machine before working on the project. `SwiftLint` can be installed using `Homebrew` via the following command:

```
brew install swiftlint
```

## External Dependencies

The ConnectedFueling App currently integrates the following external dependencies via SPM:

- [PACECloudSDK](https://github.com/pace/cloud-sdk-ios)
- [Firebase](https://github.com/firebase/firebase-ios-sdk)
- [Sentry](https://github.com/getsentry/sentry-cocoa)

Please refrain from using any other dependency managers than SPM. When integrating a new package use the `.exact(...)` option as the dependency rule and specify the appropriate version.
This will prevent any developer from running into any unwanted versioning issues or having to deal with refactoring/bug fixing due to a package introducing breaking changes.

## Localization

The localized strings are injected via the script `scripts/update_strings.sh`. It uses the tool `Lokalise` to download and generate the required string files. Please open a pull request if you wish changes to be made to the localized strings.

To access the localized strings in the source files, `SwiftGen` is used. The file `swiftgen.yml` in the root directory contains the configuration for assets and strings.

Make sure you've installed `SwiftGen` on your machine before working on the project. `SwiftGen` can be installed using `Homebrew` via the following command:

```
brew install swiftgen
```

```swift
// Accessing localized string in the source file

let onboardingAuthenticationActionTitle = L10n.onboardingAuthenticationAction
```

## Theming

In the current state, the app is available in light mode only. All of the design decisions were made based on the fact that dark mode will not be available. It is also not planned to implement a design for dark mode any time soon.

All assets are stored in their respective folders in `App/Resources/Images.xcassets`. They are organized by feature and their names are prefixed by the corresponding feature as well.

```
Onboarding Sign In Icon:
- folder: App/Resources/Images.xcassets/Onboarding/onboarding_sign_in_icon.imageset
- name: onboarding_sign_in_icon
```

Colors can be found in `App/Resources/Colors.xcassets`. They can be accessed in code via `Color+Extension` using the following syntax:

```swift
let black = Color.genericBlack
```