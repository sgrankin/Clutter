desc "Make and install appledoc documentation for the current pod"
task :doc do |t|
  require 'cocoapods'
  require 'pathname'
  require 'active_support/all'
  require 'escape'

  podspec = Pathname.new(FileList['*.podspec'].first)
  pod = Pod::Specification.from_file(podspec)
  pod.activate_platform(:ios)

  options = [
    '--project-name', pod.name + ' ' + pod.version.to_s,
    '--docset-desc', pod.description,
    '--project-company', pod.authors.keys.sort.to_sentence,
    '--docset-copyright', pod.authors.keys.sort.to_sentence,
    '--company-id', 'org.cocoapods',
    '--ignore', '.m,.mm',
    '--keep-undocumented-objects',
    '--keep-undocumented-members',
    '--exit-threshold', '2' # appledoc terminates with an exits status of 1 if a warning was logged
  ]

  docsetutil = `xcrun -find docsetutil`
  options += ['--docsetutil-path', docsetutil] if File.executable? docsetutil

  index_file = Pathname.glob('readme{*,.*}', File::FNM_CASEFOLD).first
  options += ['--index-desc', index_file.to_s] if index_file

  options += pod.source_files

  sh %{appledoc #{Escape.shell_command(options)}}
end
