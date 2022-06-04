source 'https://github.com/CocoaPods/Specs.git'

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
  end
 end
end

use_frameworks!
inhibit_all_warnings!

target 'Riada' do
  platform :ios, '11.0' 

  pod 'Applanga'
  pod 'Wormholy'
end

