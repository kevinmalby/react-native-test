fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios loadAscApiKey

```sh
[bundle exec] fastlane ios loadAscApiKey
```

Load App Store Connect APi Key info for use in other lanes

### ios build

```sh
[bundle exec] fastlane ios build
```

Builds ios app

----


## Android

### android prepareAndroid

```sh
[bundle exec] fastlane android prepareAndroid
```

Cleans android folder

### android updateVersion

```sh
[bundle exec] fastlane android updateVersion
```

Updates the android version in the build.gradle file

### android buildAab

```sh
[bundle exec] fastlane android buildAab
```

Builds the aab file

### android buildApk

```sh
[bundle exec] fastlane android buildApk
```

Builds the apk file

### android uploadToTestFairy

```sh
[bundle exec] fastlane android uploadToTestFairy
```

Uploads the build to TestFairy

### android buildAndUploadForTest

```sh
[bundle exec] fastlane android buildAndUploadForTest
```

Builds and uploads binary for test

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
