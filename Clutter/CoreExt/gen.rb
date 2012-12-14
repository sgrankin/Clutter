#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -wKU
require 'pathname'
require 'rake'

pwd = Pathname.new(__FILE__).expand_path.dirname
headers = Pathname.glob("#{pwd}/*/*.h")

headers.each do |h|
  puts %{#include "#{h.basename}"}
end
