namespace :version do
  def current_version
    "%s (%s)" % [`agvtool what-marketing-version -terse1`.chomp, `agvtool what-version -terse`.chomp]
  end

  desc 'Bump the build number'
  task :bump do |t|
    sh %{agvtool next-version > /dev/null}
    puts current_version
  end

  desc 'Set the project version, bumping the build number'
  task :set, [:version] do |t, args|
    raise 'version:set parameter required!' unless args.version
    sh %{agvtool new-marketing-version #{args.version} > /dev/null}
    sh %{agvtool next-version > /dev/null}
    puts current_version
  end

  desc 'Display the current xc project version'
  task :show do |t|
    puts current_version
  end
end
desc 'Display the current project version'
task :version => ['version:show']
