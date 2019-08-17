Pod::Spec.new do |s|
  s.name         = "CRNetworking"
  s.version      = "1.0.0"
  s.summary      = "Simple Networking Stack"
  s.description  = <<-DESC
    A thin network stack that relies on Codable responses
  DESC
  s.homepage     = "https://github.com/crsantos/CRNetworking"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Carlos Santos" => "carlosricardosantos@gmail.com" }
  s.social_media_url   = "http://www.twitter.com/crsantos"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/crsantos/CRNetworking.git", :tag => s.version.to_s }
  s.cocoapods_version = '>= 1.7'
  s.swift_versions = ['4.2', '5.0']
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
