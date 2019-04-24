#
# Be sure to run `pod lib lint TCardView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TCardView'
  s.version          = '0.1.0'
  s.summary          = '带缩放效果的轮播图'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RainyMask'
  s.screenshots     = 'https://raw.githubusercontent.com/RainyMask/TCardView/master/Example/TCardView/demo1.png', 'https://raw.githubusercontent.com/RainyMask/TCardView/master/Example/TCardView/demo2.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1370254410@qq.com' => 'daitao@chaorey.com' }
  s.source           = { :git => 'https://github.com/RainyMask/TCardView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://blog.csdn.net/NB_Token'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TCardView/Classes/**/*'
  
  s.resource_bundles = {
    'TCardView' => ['TCardView/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
end
