source 'https://github.com/CocoaPods/Specs.git'
# declare to use Playwire repository 
source 'https://github.com/intergi/playwire-ios-podspec'

platform :ios, '16.0'
use_frameworks!

playwire_version = '10.1.2'
firebase_version = '10.28.0'


################################
########## Total ###############
################################

abstract_target 'Total' do
  
  pod 'Playwire', playwire_version
  pod 'FirebaseAnalytics', firebase_version

  target 'PlaywireSDKAppsSwift' do
  end

  target 'PlaywireSDKAppsObjC' do
  end

  target 'PlaywireSDKAppsSwiftUI' do
  end

end


#####################################
############# COPPA #################
#####################################

abstract_target 'Coppa' do
  
  pod 'Playwire/Coppa', playwire_version
  
  target 'PlaywireSDKAppsSwift_COPPA' do
  end
  
  target 'PlaywireSDKAppsObjC_COPPA' do
  end
  
  target 'PlaywireSDKAppsSwiftUI_COPPA' do
  end
  
end
