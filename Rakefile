desc 'Update headers in all files to match the LICENSE'
task :license do
  license = open('LICENSE') do |io|
    io.lines.map {|line| ('// ' + line).rstrip + $/}
  end

  sources = FileList['Clutter/**/*.{h,m}']
  sources.each do |source|
    # drop the leading comment block and append the license
    lines = open(source) {|io| io.lines.to_a}

    # check if the license was changed; avoid rewriting the file if not
    first_line = lines.find_index {|l| /^\/\// !~ l}
    old_license, lines = lines[0...first_line], lines[first_line..lines.length]
    next if old_license == license
    open(source, 'w') {|io| io.write((license + lines).join)}
  end
end
