Pod::Spec.new do |s|
  s.name         = "MUSharedWebCredential"
  s.version      = "0.0.1"
  s.summary      = "MUSharedWebCredential is a little class that takes all the pain out of working with passwords saved by Safari AutoFill."
  s.description  = <<-DESC
                   MUSharedWebCredential is a little class that takes all the pain out of working with passwords saved by Safari AutoFill. It lets you work with those passwords in Swift apps, and neatly hides the fact that the necessary API methods don't exist in iOS 7 and Xcode 5.

                   Before you can use this class, you must set up your app-website association. See the 2014 WWDC video “Your App, Your Website, and Safari” for instructions.
                   DESC
  s.homepage     = "https://github.com/meetup/MUSharedWebCredential"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Phil Tang" => "phil.sj.tang@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/meetup/MUSharedWebCredential.git", :tag => "v0.0.1" }
  s.source_files = "Classes/**/*.{h,m}"
  s.framework    = 'Security'
  s.requires_arc = true
end
