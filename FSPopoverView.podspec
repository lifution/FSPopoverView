Pod::Spec.new do |s|
  s.name     = 'FSPopoverView'
  s.version  = '3.1.0'
  s.summary  = '`FSPopoverView` is an iOS customizable view that displays a popover view.'
  s.homepage = 'https://github.com/lifution/FSPopoverView'
  s.author   = 'Sheng'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.source   = {
    :git => 'https://github.com/lifution/FSPopoverView.git',
    :tag => s.version.to_s
  }
  
  s.requires_arc = true
  s.swift_version = '5'
  s.ios.deployment_target = '12.0'

  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.source_files = 'Sources/**/*.swift'
end
