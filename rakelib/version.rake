def get_version
  return `#{AGVTOOL} what-marketing-version -terse1`.chomp
end

def set_version version
  sh %{#{AGVTOOL} new-marketing-version #{version} > /dev/null}

  podspec = FileList['*.podspec'].first
  tmp = podspec + '~'

  open(tmp, 'w') do |fout|
    open(podspec) do |fin|
      fin.each_line do |l|
        fout << l.gsub(/(?<pre>version.*=\s*')((\d|\.)+)(?<post>.*)/) do
          m = $~
          m[:pre] + get_version[1..-1] + m[:post]
        end
      end
    end
  end
  mv tmp, podspec
end

# version string to array
def vers_string_to_array vstring
  m = /v?(?<x>\d+)(\.(?<y>\d+)(\.(?<z>\d+))?)?/.match(vstring)
  x, y, z = m[:x], m[:y], m[:z]
  vs = [x,y,z].map{|v| (v||0).to_i}
  vs = [0, 0, 1] unless  vs.find{|v| v != 0}
  return vs
end

# version array to string
def vers_array_to_string vs
  return 'v' + vs.join('.')
end

def vers_normalize_string vstring
  return vers_array_to_string(vers_string_to_array(vstring))
end

def get_git_version
  # return the distance from last tag, if there is a tag...
  return `#{GIT} describe --tags --always --dirty`.chomp.sub(/^#{get_version}-/,'')
end

def pretty_version
  puts "%s (%s)" % [get_version, get_git_version]
end

def git_clean_index?
  return `git status --porcelain`.split($/).grep(/^\S/).empty?
end

def git_clean?
  return `git status --porcelain`.split($/).grep(/^\S|^ \S/).empty?
end

def git_assert_clean
  fail "Cowardly refusing to work on modified tree/index" unless git_clean?
end

task :git_assert_clean do |t|
  git_assert_clean
end

namespace :version do
  desc "Display the current version"
  task :show do |t|
    puts pretty_version
  end

  desc "Bump the :major, :minor, or :patch version"
  task :bump, [:version] do |t, args|
    args.with_defaults(:version => :patch)
    v = vers_string_to_array get_version
    i = args.version == :major ? 0 : args.version == :minor ? 1 : 2
    v[i] += 1
    set_version vers_array_to_string(v)
    puts pretty_version
  end

  desc "Set the marketing version CFBundleShortVersionString"
  task :set, [:version] do |t, args|
    args.with_defaults(:version => get_version)
    set_version vers_normalize_string(args.version)
    puts pretty_version
  end

  desc "Tag the current version in git"
  task :tag do |t|
    git_assert_clean
    sh %{#{GIT} tag #{get_version}}
  end

  task :commit_changes do |t|
    FileList['*.podspec', '**/*-Info.plist'].each do |f|
      sh %{#{GIT} add "#{f}"}
    end
    sh %{#{GIT} commit -m "Version #{get_version}"}
  end

  desc "Bump the patch version, commit changed plists, and tag"
  task :bumptag => [:git_assert_clean, :bump, :commit_changes, :tag]
end
desc 'Display the current version'
task :version => ['version:show']

desc "Create Info.plist.h with BUNDLE_GIT_VERSION"
task :make_info_plist do |t|
  # generate Info.plist.h
  open('Info.plist.h', 'w') do |io|
    io << "#define BUNDLE_GIT_VERSION #{get_git_version}\n"
  end
end
