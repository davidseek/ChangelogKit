#
# Be sure to run `pod lib lint ChangelogKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChangelogKit'
  s.version          = '0.1.1'
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



Showing Recent Messages
PhaseScriptExecution [CP]\ Embed\ Pods\ Frameworks /Users/dseek/Library/Developer/Xcode/DerivedData/Voice_Pitch_Analyzer-eiaomtyvvulmbqhdiudxujtdhyki/Build/Intermediates.noindex/Voice\ Pitch\ Analyzer.build/Debug-iphoneos/Voice\ Pitch\ Analyzer.build/Script-A9E6C931F939A7CDB587EB23.sh (in target 'Voice Pitch Analyzer' from project 'Voice Pitch Analyzer')
    cd /Volumes/workplace/davidseek/voice-pitch-analyzer
    /bin/sh -c /Users/dseek/Library/Developer/Xcode/DerivedData/Voice_Pitch_Analyzer-eiaomtyvvulmbqhdiudxujtdhyki/Build/Intermediates.noindex/Voice\\\ Pitch\\\ Analyzer.build/Debug-iphoneos/Voice\\\ Pitch\\\ Analyzer.build/Script-A9E6C931F939A7CDB587EB23.sh

mkdir -p /Users/dseek/Library/Developer/Xcode/DerivedData/Voice_Pitch_Analyzer-eiaomtyvvulmbqhdiudxujtdhyki/Build/Products/Debug-iphoneos/Voice Pitch Analyzer.app/Frameworks
rsync --delete -av --filter P .*.?????? --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "/Users/dseek/Library/Developer/Xcode/DerivedData/Voice_Pitch_Analyzer-eiaomtyvvulmbqhdiudxujtdhyki/Build/Products/Debug-iphoneos/Beethoven/Beethoven.framework" "/Users/dseek/Library/Developer/Xcode/DerivedData/Voice_Pitch_Analyzer-eiaomtyvvulmbqhdiudxujtdhyki/Build/Products/Debug-iphoneos/Voice Pitch Analyzer.app/Frameworks"
building file list ... done
Beethoven.framework/
Beethoven.framework/Beethoven
Beethoven.framework/Info.plist

sent 481361 bytes  received 70 bytes  962862.00 bytes/sec
total size is 481075  speedup is 1.00
/Volumes/workplace/davidseek/voice-pitch-analyzer/Pods/Target Support Files/Pods-Voice Pitch Analyzer/Pods-Voice Pitch Analyzer-frameworks.sh: line 131: ARCHS[@]: unbound variable
Command PhaseScriptExecution failed with a nonzero exit code

