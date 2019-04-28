Pod::Spec.new do |s|
  s.name          = "CwlViewsTesting"
  s.version       = "0.1.0"
  
  s.summary       = "A parser/decomposer for CwlViews to enable testing."
  s.description   = <<-DESC
    A support library for CwlViews to allow the decomposition of view binders for testing.
  DESC
  
  s.homepage      = "https://github.com/mattgallagher/CwlViews"
  s.license       = { :type => "ISC", :file => "LICENSE.txt" }
  s.author        = "Matt Gallagher"
  s.swift_version = '5.0'
  
  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.13"

  s.dependency 'CwlUtils', '~> 2.2.0'
  s.dependency 'CwlSignal', '~> 2.2.0'
  s.dependency 'CwlViews', '~> 0.1.0'
  
  s.source        = { :git => "https://github.com/mattgallagher/CwlViews.git", :tag => "0.1.0" }
  s.source_files  = "Sources/CwlViewsTesting/**/*.{swift,h}"
end
