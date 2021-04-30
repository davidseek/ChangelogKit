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

## API
- `useForce` 
  - `true`, presents the Changelog in a modal
  - `false`, presents a banner, with action buttons. Close, and present Changelog.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

ChangelogKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ChangelogKit'
```

## Author

davidseek, david@davidseek.com

## License

ChangelogKit is available under the MIT license. See the LICENSE file for more info..
