#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -wKU
require 'pathname'
require 'rake'

pwd = Pathname.new(__FILE__).expand_path.dirname
headers = Pathname.glob("#{pwd}/*/*.h")

headers.each do |h|
  if h.basename.to_s.sub(/#{h.extname}$/, '') == "CL#{h.dirname.basename}"
    puts <<-EOS
#if __has_include("#{h.basename}")
#include "#{h.basename}"
#endif

    EOS
  end
end
