#
# Be sure to run `pod lib lint ENNDynamic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ENNDynamic'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ENNDynamic.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "项目模块化设计重构，类似微信朋友圈,由于每个公司数据结构/需求不一致,部分功能代码可借鉴参考"

  s.homepage         = 'https://github.com/zhangrongwu/ENNDynamic'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangrongwu' => 'zhangrongwuios@sina.com' }
  s.source           = { :git => 'https://github.com/zhangrongwu/ENNDynamic.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ENNDynamic/Classes/**/*'
  s.resources  = 'ENNDynamic/*.{bundle,png}'

  s.public_header_files = 'Pod/Classes/**/*.h'
  
  s.frameworks = ['UIKit','AVFoundation']
  
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'Masonry',  '~> 1.1.0'
  s.dependency 'YYKit',  '~> 1.0.9'
  s.dependency 'SDWebImage',   '~> 3.7.6'
  s.dependency 'MBProgressHUD',    '~> 1.0.0'
  s.dependency 'MJExtension',  '~> 3.0.10'
  s.dependency 'MJRefresh',    '~> 3.1.14.1'
  s.dependency 'TZImagePickerController',  '~> 1.7.9'
  s.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.6'
  
  s.dependency 'MLLabel',  '~> 1.9.1'















end
