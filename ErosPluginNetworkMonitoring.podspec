#
#  Be sure to run `pod spec lint QBMDatePickerPlugin.podspec' to ensure this is a

Pod::Spec.new do |s|



  s.name         = "ErosPluginNetworkMonitoring"
  s.version      = "0.2.0"
  s.summary      = "eros-plugin-network-monitoring"

  s.description  = <<-DESC
                  Eros 断网监测，弹框提示用户
                   DESC

  s.homepage     = 'https://github.com/super-chen/eros-plugin-iOS-network-monitoring'

  s.license      = "MIT"

  s.author       = { "Frank Chen" => "superchen@live.cn" }

  s.platform     = :ios

  s.ios.deployment_target = "8.0"

  s.source       = { :git => 'https://github.com/super-chen/eros-plugin-iOS-network-monitoring.git', :tag => s.version }

  s.dependency 'BMBaseLibrary', '1.2.4'

  s.source_files = "Classes/**/*.{h,m}"

  s.resources = "Classes/Resources/*"

  s.requires_arc = true

end
