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

  pod 'SwiftKeychainWrapper'

  pod 'Firebase'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage'
  pod 'Firebase/Firestore'
  pod 'Firebase/Functions'  
  pod 'Firebase/DynamicLinks'
  pod 'CodableFirebase'
  pod 'FirebaseFirestoreSwift'
  pod 'GeoFire/Utils'
  pod 'GoogleSignIn'
  
  pod 'Applanga'
  pod 'Wormholy'
  pod 'Kingfisher', '~> 5.0'
end

