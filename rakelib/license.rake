def update_license
  fail 'Must set SOURCES to specify which files to update with LICENSE' unless SOURCES

  license = open('LICENSE') do |io|
    # strip all trailing spaces, make into a comment
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
  update_license
end

task :license_fail_on_update do
  # fail the commit if there were updates to any files; we're too dumb to resolve this
  fail "Files updated with LICENSE" if update_license
end
