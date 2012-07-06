# highlight stderr output when running in a tty
if $stderr.tty?
  require 'term/ansicolor'
  include Term::ANSIColor
  class << $stderr
    alias_method :__puts_nocolor__, :puts
    def puts *args
      __puts_nocolor__ *(args.map{|a| a.to_s.yellow})
    end
  end
end
