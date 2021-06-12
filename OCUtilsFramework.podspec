

Pod::Spec.new do |s|
  s.name             = 'OCUtilsFramework'
  s.version          = '0.1.0'
  s.summary          = 'This is demo for utils class.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ajayMishra1/OCUtilsFramework.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ajayMishra1' => 'mishraajay95124@gmail.com' }
  s.source           = { :git => 'https://github.com/ajayMishra1/OCUtilsFramework.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'Classes/**/*'
  
  # s.resource_bundles = {
  #   'OCUtilsFramework' => ['OCUtilsFramework/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
