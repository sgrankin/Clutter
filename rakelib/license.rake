def license
  raise 'Must set SOURCES to specify which files to update with LICENSE' if !SOURCES

  license = open('LICENSE') do |io|
    io.lines.map {|line| ('// ' + line).rstrip + $/}
  end

  changed = []
  SOURCES.each do |source|
    # drop the leading comment block and append the license
    lines = open(source) {|io| io.lines.to_a}

    # check if the license was changed; avoid rewriting the file if not
    first_line = lines.find_index {|l| /^\/\// !~ l}
    old_license, lines = lines[0...first_line], lines[first_line..lines.length]
    next if old_license == license

    open(source, 'w') {|io| io.write((license + lines).join)}
    changed << source
  end
  return changed.count > 0 ? changed : nil
end

desc 'Update headers in all files to match the LICENSE'
task :license do
  license
end

task :license_fail_on_update do
  fail if license # fail the commit if there were updates to any files
end

task 'githooks:precommit' => [:license_fail_on_update]
