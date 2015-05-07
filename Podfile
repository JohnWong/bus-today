source 'https://gitcafe.com/yellowxz/Specs.git'

target :BusRider do
    pod 'STHTTPRequest'
    pod 'SVProgressHUD'
    pod 'AHKActionSheet'
    pod 'UMengAnalytics'
    pod 'Appirater', '~> 2.0.4'
    pod 'SGNavigationProgress', :podspec => 'https://raw.githubusercontent.com/JohnWong/SGNavigationProgress/master/SGNavigationProgress.podspec'
    pod 'CBStoreHouseRefreshControl', :podspec => 'https://raw.githubusercontent.com/JohnWong/CBStoreHouseRefreshControl/master/CBStoreHouseRefreshControl.podspec'
    pod 'Reveal-iOS-SDK', '~> 1.0.6',:configurations => ['Debug']
end

target :Today do
    platform :ios, '8.0'
    pod 'STHTTPRequest'
end

target :'BusRider WatchKit Extension' do
    platform :ios, '8.0'
    pod 'STHTTPRequest'
end

inhibit_all_warnings!

#post_install do |installer_representation|
#    installer_representation.project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'SV_APP_EXTENSIONS=1']
#        end
#    end
#end