platform :ios, '9.0'

target 'Momentum' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Momentum
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'SVProgressHUD'
    pod 'ChameleonFramework'
    pod 'SwiftLint'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end

  target 'MomentumTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MomentumUITests' do
    inherit! :search_paths
    # Pods for testing
  end

