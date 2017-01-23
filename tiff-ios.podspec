Pod::Spec.new do |s|
  s.name             = 'tiff-ios'
  s.version          = '1.0.0'
  s.license          =  {:type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'iOS SDK for Tagged Image File Format'
  s.homepage         = 'https://github.com/ngageoint/geopackage-tiff-ios'
  s.authors          = { 'NGA' => '', 'BIT Systems' => '', 'Brian Osborn' => 'osbornb@bit-sys.com' }
  s.social_media_url = 'https://twitter.com/NGA_GEOINT'
  s.source           = { :git => 'https://github.com/ngageoint/geopackage-tiff-ios.git', :tag => s.version }
  s.requires_arc     = true

  s.platform         = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'tiff-ios/**/*.{h,m}'

  s.resource_bundle = { 'TIFF' => ['tiff-ios/**/*.plist'] }
  s.frameworks = 'Foundation'
end
