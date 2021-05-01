#
# Be sure to run `pod lib lint ChangelogKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChangelogKit'
  s.version          = '0.1.5'
  s.summary          = 'A library that offers tools to display a changelog using webviews and user defaults.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Using only a few lines of code, you can add a changelog for your users. The log will only ever be seen if the user is getting a new update.
                       DESC

  s.homepage         = 'https://github.com/davidseek/ChangelogKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'davidseek' => 'david@davidseek.com' }
  s.source           = { :git => 'https://github.com/davidseek/ChangelogKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/DavidSeek'

  s.ios.deployment_target = '12.0'

  s.source_files = 'ChangelogKit/Classes/**/*'

  s.swift_version = '4.0'
  
  # s.resource_bundles = {
  #   'ChangelogKit' => ['ChangelogKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end