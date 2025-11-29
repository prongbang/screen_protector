#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint screen_protector.podspec --verbose --no-clean` to validate before publishing.
# Run `pod install --repo-update --verbose` to uppdate new version.
#
Pod::Spec.new do |s|
  s.name             = 'screen_protector'
  s.version          = '1.4.8'
  s.summary          = 'Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and iOS.'
  s.description      = <<-DESC
Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and iOS.
                       DESC
  s.homepage         = 'https://github.com/prongbang/screen_protector'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'prongbang'
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'
  s.dependency       'ScreenProtectorKit', '1.4.4'
  s.platform         = :ios, '11.0'
  s.swift_version    = ["4.0", "4.1", "4.2", "5.0", "5.1", "5.2", "5.3", "5.4", "5.5"]
end
