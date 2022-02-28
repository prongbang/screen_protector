#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint screen_protector.podspec --verbose --no-clean` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'screen_protector'
  s.version          = '1.0.0'
  s.summary          = 'Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and iOS.'
  s.description      = <<-DESC
Safe Data Leakage via Application Background Screenshot and Prevent Screenshot for Android and iOS.
                       DESC
  s.homepage         = 'https://github.com/prongbang/screen_protector'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'prongbang'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'ScreenProtectorKit', '1.0.5'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = ["4.0", "4.1", "4.2", "5.0", "5.1", "5.2", "5.3", "5.4", "5.5"]
end
