platform :ios, '14'

target 'MovieDBCombine' do
  use_frameworks!
	pod 'Kingfisher' 
	pod 'SnapKit'
	pod 'CombineCocoa'

end

post_install do |installer|
	installer.generated_projects.each do |project|
		project.targets.each do |target|
			target.build_configurations.each do |config|
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
			end
		end
	end
end
