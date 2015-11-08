source 'https://gitcafe.com/yellowxz/Specs.git'

def shared_pods
    pod 'STHTTPRequest2', :podspec => 'https://raw.githubusercontent.com/JohnWong/STHTTPRequest/master/STHTTPRequest2/STHTTPRequest2.podspec'
end

target :BusRider do
    shared_pods
    pod 'SVProgressHUD'
    pod 'AHKActionSheet'
    pod 'UMengAnalytics'
    pod 'UIViewAdditions'
    pod 'Appirater', '~> 2.0.4'
    pod 'SGNavigationProgress', :podspec => 'https://raw.githubusercontent.com/JohnWong/SGNavigationProgress/master/SGNavigationProgress.podspec'
    pod 'CBStoreHouseRefreshControl', :podspec => 'https://raw.githubusercontent.com/JohnWong/CBStoreHouseRefreshControl/master/CBStoreHouseRefreshControl.podspec'
#    pod 'Reveal-iOS-SDK', '~> 1.5.1',:configurations => ['Debug']
end

target :Today do
    platform :ios, '8.0'
    shared_pods
    pod 'UIViewAdditions'
end

target :'BusRider WatchKit Extension' do
    platform :ios, '8.0'
    shared_pods
end

target :'watchOS2 Extension' do
    platform :watchos, '2.0'
    shared_pods
end

inhibit_all_warnings!

#post_install do |installer_representation|
#    installer_representation.project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'SV_APP_EXTENSIONS=1']
#        end
#    end
#end