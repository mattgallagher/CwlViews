Pod::Spec.new do |s|
  s.name          = "CwlViews"
  s.version       = "0.1.0"
  
  s.summary       = "A declarative view-construction framework for iOS and macOS applications"
  s.description   = <<-DESC
    A collection of wrappers around iOS UIKit and macOS AppKit class construction, making views declaratively constructed and reactively driven.
  DESC
  
  s.homepage      = "https://github.com/mattgallagher/CwlViews"
  s.license       = { :type => "ISC", :file => "LICENSE.txt" }
  s.author        = "Matt Gallagher"
  s.swift_version = '5.0'
  
  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.13"
  
  s.source        = { :git => "https://github.com/mattgallagher/CwlViews.git", :tag => "0.1.0" }
  s.source_files  = "Sources/CwlViews/*.{swift,h}"
end
