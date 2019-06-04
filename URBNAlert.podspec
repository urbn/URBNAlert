Pod::Spec.new do |s|
s.name             = 'URBNAlert'
s.version          = '3.0.1'
s.summary          = 'A swift version of URBNAlert by Ryan Garchinsky.'


s.homepage         = 'https://github.com/URBN/URBNAlert'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Kevin Taniguchi' => 'ktaniguchi@urbn.com' }
s.source           = { :git => 'https://github.com/urbn/URBNAlert.git', :tag => s.version.to_s }
s.platform         = :ios, '10.0'
s.requires_arc     = true
s.swift_version    = "5.0"
s.source_files     = 'URBNAlert/Classes/**/*'
s.dependency 'URBNSwiftyConvenience', '~> 1.5'
end
