# encoding: UTF-8
require 'bundler/setup'
require 'shellwords'

SOURCES = FileList['{Clutter,Specs}/**/*.{h,hpp,m,mm,c,cpp,cxx}']

def xcrun_find tool
  return `xcrun -find #{tool}`.chomp
end

AGVTOOL = xcrun_find :agvtool
GIT     = xcrun_find :git

desc "Git pre-commit hook"
task :precommit => [:license_fail_on_update]

desc "Xcode prebuild script"
task :prebuild => [:make_info_plist, :make_images]

file 'Readme.html' => ['Readme.markdown']
task :readme => ['Readme.html'] do |t|
  sh %{open #{t.prerequisites.shelljoin}}
end
