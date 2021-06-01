platform :ios, '9.0'

target 'myHSJournal' do
   pod 'UICheckbox'
   pod 'DropDown'
   pod 'Tabman', '~> 2.5.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
