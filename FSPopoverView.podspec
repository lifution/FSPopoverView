Pod::Spec.new do |s|
  s.name     = 'FSPopoverView'
  s.version  = '1.0.0'
  s.summary  = '`FSPopoverView` is an iOS customizable view that displays a bubble style view.'
  s.homepage = 'https://github.com/lifution/Popover'
  s.author   = 'Sheng'
  s.license  = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  s.source   = {
    :git => 'git@github.com:lifution/Popover.git',
    :tag => s.version.to_s
  }
  s.ios.deployment_target = '11.0'
  s.source_files = 'FSPopoverView/Classes/**/*'
end
