source 'https://github.com/CocoaPods/Specs.git'

def shared_pods
    pod 'STHTTPRequest2', :podspec => 'https://raw.githubusercontent.com/JohnWong/STHTTPRequest/master/STHTTPRequest2/STHTTPRequest2.podspec'
end

target :BusRider do
    shared_pods
    pod 'SVProgressHUD'
    pod 'AHKActionSheet'
    pod 'UIViewAdditions'
    pod 'Appirater'
    pod 'SGNavigationProgress', :podspec => 'https://raw.githubusercontent.com/JohnWong/SGNavigationProgress/master/SGNavigationProgress.podspec'
    pod 'CBStoreHouseRefreshControl', :podspec => 'https://raw.githubusercontent.com/JohnWong/CBStoreHouseRefreshControl/master/CBStoreHouseRefreshControl.podspec'
    pod 'Reveal-SDK', '~> 11', :configurations => ['Debug']
    pod 'Crashlytics'
end

target :Today do
    platform :ios, '9.0'
    shared_pods
    pod 'UIViewAdditions'
end

target :'BusRider WatchKit Extension' do
    platform :watchos, '2.0'
    shared_pods
end

inhibit_all_warnings!