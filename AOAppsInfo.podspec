Pod::Spec.new do |s|
  s.name         = "AOAppsIngo"
  s.version      = "0.0.1"
  s.summary      = "Part of Parse info application"
  s.description  = "Part of info application responsible for presentation of our apps"
  s.homepage     = "https://github.com/alekoleg/AOAppsInfo.git"
  s.license      = 'MIT'
  s.author       = { "Oleg Alekseenko" => "alekoleg@gmail.com" }
  s.source       = { :git => "https://github.com/alekoleg/AOAppsInfo.git", :tag => s.version.to_s}
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'VZPolicCollectionView', :git => 'https://github.com/alekoleg/VZPolicCollectionView'
  s.dependency 'AOInfoNetManager', :git => 'https://github.com/alekoleg/AOInfoNetManager'
  s.dependency 'CLPLoading', :git => 'https://github.com/alekoleg/CLPLoading'
  s.dependency 'UIActivityIndicator-for-SDWebImage', '~> 1.2'
  
end
