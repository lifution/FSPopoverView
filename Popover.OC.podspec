Pod::Spec.new do |s|
	s.name = "Popover.OC"
	s.version = "0.2"
	s.summary = "A simple Popover of Menu"
	s.license = { :type => "MIT", :file => "LICENSE" }
	s.homepage = "https://github.com/lifution/Popover"
	s.author = { "StevenLee" => "https://github.com/lifution" }
	s.source = { :git => "https://github.com/lifution/Popover.git", :tag => "0.2" }
	s.requires_arc = true
	s.platform = :ios, "6.0"
	s.source_files = "PopoverView/*", "*.{h,m}"
end