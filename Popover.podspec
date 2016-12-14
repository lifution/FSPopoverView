Pod::Spec.new do |s|
	s.name = "Popover"
	s.version = "1.0"
	s.summary = "A simple Popover of Menu"
	s.license = { :type => "MIT", :file => "LICENSE" }
	s.homepage = "https://github.com/lifution/Popover"
	s.author = { "Steven" => "https://github.com/lifution" }
	s.source = { :git => "https://github.com/lifution/Popover.git", :tag => "1.0.0" }
	s.requires_arc = true
	s.platform = :ios, "6.0"
	s.source_files = "PopoverView/*", "*.{h,m}"
end