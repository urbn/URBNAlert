Pod::Spec.new do |s|
  s.name             = "URBNAlert"
  s.version          = "1.9.2"
  s.summary          = "A custom alert view based off of UIAlertController but highly customizable."
  s.homepage         = "https://github.com/urbn/URBNAlert"
  s.license          = 'MIT'
  s.author           = { "urbn" => "jgrandelli@urbn.com" }
  s.source           = { :git => "https://github.com/urbn/URBNAlert.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.dependency 'URBNConvenience', '> 0.8.2'

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'URBNAlert' => ['Pod/Assets/*.png']
  }
end
