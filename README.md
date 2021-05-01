# ChangelogKit

[![CI Status](https://img.shields.io/travis/davidseek/ChangelogKit.svg?style=flat)](https://travis-ci.org/davidseek/ChangelogKit)
[![Version](https://img.shields.io/cocoapods/v/ChangelogKit.svg?style=flat)](https://cocoapods.org/pods/ChangelogKit)
[![License](https://img.shields.io/cocoapods/l/ChangelogKit.svg?style=flat)](https://cocoapods.org/pods/ChangelogKit)
[![Platform](https://img.shields.io/cocoapods/p/ChangelogKit.svg?style=flat)](https://cocoapods.org/pods/ChangelogKit)

ChangelogKit is a library that offers a drop-in Changelog experience, written in Swift.

```swift
import ChangelogKit
// Define the URL where your changelog is hosted.
// Best to use with md2site.com changelog template ☺️
ChangelogKit.changelogURL = "https://voicepitchanalyzerchangelog.davidseek.md2site.com/"

// Pick a good moment in your App where it's appropriate 
// to let the user know, that he has been updated to a new version.
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ChangelogKit.ready(on: self, useForce: true)
}

```

ChangelogKit uses the `UserDefaults` to determine, if the user has already seen this `AppVersion`. A banner on the top of the screen, indicating that the app has been updated to the latest version, will be shown. When the user selects `See What's New`, then a modally presented `WKWebViewController` opens, presenting the changelog that has been embedded via `URL`. 

![Screenshots](https://firebasestorage.googleapis.com/v0/b/md2site.appspot.com/o/changelogkit.png?alt=media&token=46ea2e1e-ec2a-43e9-8f1c-04ba003e9124)

## API

- `useForce` 
  - `true`, presents the Changelog in a modal
  - `false`, presents a banner, with action buttons. Close, and present Changelog.

## Theming

The `ChangelogKitTheme` object offers a simple way to customize the Changelog experience with your Application Corporate Identity.

```swift
ChangelogKit.theme = ChangelogKitTheme(
    navigationBarTintColor: .white, 
    backgroundColor: .black)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

ChangelogKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ChangelogKit'
```

## Author

[David Seek](https://twitter.com/DavidSeek)

## License

ChangelogKit is available under the MIT license. See the LICENSE file for more info..
