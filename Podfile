source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'pg103’ do
  pod 'EZSwiftExtensions', :git => 'https://github.com/goktugyil/EZSwiftExtensions.git'
  pod 'SwiftyJSON'
  pod 'SwiftyBeaver'
  pod 'SnapKit'
  pod 'SDWebImage'
  pod 'RZViewActions'
  pod 'SwiftyButton'
  pod 'Bolts'
  pod 'pop'
  pod 'JTProgressHUD'
  pod 'KeychainAccess'

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
