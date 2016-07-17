class Regextruder
  class Posix
    class << self
      def all
        (0x00..0x7e).map(&:chr)
      end
      [:digit, :lower, :upper, :alpha, :alnum, :blank, :cntrl, :graph, :print, :punct, :space, :xdigit, :word].each do |set|
        define_method(set) do
          all.select do |c|
            c.match /[[:#{set.to_s}:]]/
          end
        end
      end
    end
  end
end
