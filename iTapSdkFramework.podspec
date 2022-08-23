Pod::Spec.new do |spec|
  spec.name         = 'iTapSdkFramework'
  spec.module_name  = 'iTapSdkFramework'
  spec.version      = '1.0'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/Minhvv94/iTapSdkFramework'
  spec.authors      = { 'Minhvv' => 'minhvv@vtvlive.vn' }
  spec.summary      = 'SDK Login iOS and OS X.'
  spec.requires_arc    = true
  spec.source       = { :git => 'https://github.com/Minhvv94/iTapSdkFramework.git', :tag => '1.0.0' }
  spec.swift_version = '5.0'
  spec.frameworks = 'UIKit'
end