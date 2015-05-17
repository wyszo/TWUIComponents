Pod::Spec.new do |s|
  s.name         = "TWUIComponents"
  s.version      = "0.1"
  s.summary      = "Library containing iOS components I use in my projects"
  s.homepage     = "https://github.com/wyszo/TWUIComponents"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = "Tomasz W"
  s.platform = :ios, '7.0'
  s.social_media_url   = "http://twitter.com/Wyszo"
  s.source       = { :git => "https://github.com/wyszo/TWUIComponents.git" }
  s.source_files  = "TWUIComponents", "TWUIComponents/**/*.{h,m}"
  s.exclude_files = "TWUIComponents/Exclude", "TWUIComponents/Pods"
end
