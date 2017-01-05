Pod::Spec.new do |s|

  s.name         = "SLStatisticsView"
  s.version      = "0.1.1"
  s.summary      = "Offer a easy to built a statisticsView For iOS"
  s.description  = <<-DESC
                   It is a marquee view used on iOS, which implement by Objective-C.
                     DESC

  s.homepage     = "https://github.com/cslmark/SLStatisticsView"
  s.license      = "MIT"
  s.author             = { "cslmark" => "chensl@hadlinks.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/cslmark/SLStatisticsView.git", :tag => "0.1.1", :commit => "3c7f1bad719f88ab025d012bf216e364bcb8bdd0" }
  s.source_files  = "SLStatisticView/*.{h,m}"
  s.framework  = "Foundation","UIKit"
  s.requires_arc = true
end
