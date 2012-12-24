def redcarpet_make source, target
  rc_parse = %w{no_intra_emphasis tables fenced_code_blocks autolink strikethrough space_after_headers superscript}
  rc_render = %w{} # hard_wrap
  sh %{redcarpet #{rc_parse.map{|v| "--parse-"+v}.join(' ')} --smarty #{source} > #{target}}
end

rule '.html' => ['.md'] do |t|
  redcarpet_make t.source, t.name
end

rule '.html' => ['.markdown'] do |t|
  redcarpet_make t.source, t.name
end

