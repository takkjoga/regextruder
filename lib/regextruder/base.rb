class Regextruder
  class Base
    attr_reader :result, :powers_map
    def self.build(pattern)
      self.new(pattern)
    end

    def initialize(pattern)
      @pattern = pattern
      @negate = false
      @candidate = []
      @interval = 1
      @powers_map = {multi: [], add: []}
      @result = []
      build
      compile
    end

    def build
      Regexp::Scanner.scan /#{@pattern}/ do |type, token, text|
        #puts "type: #{type}; token: #{token}; text: #{text}"
        send(token, text)
      end
    end

    def compile
      @interval.times do
        @result << @candidate.sample.to_s
      end
      if @powers_map[:multi].empty? && @powers_map[:add].empty?
        @powers_map[:multi] << @candidate.count
      end
    end

    def candidate(c)
      if @negate
        @negate = false
        if @candidate.empty?
          @candidate = Posix.all
        end
        @candidate -= c
      else
        @candidate += c
      end
    end

    # no operation
    def alternation(text); end
    def intersection(text); end

    # not
    def negate(text)
      @negate = true
    end

    # fix interval
    def interval(text)
      i = text.gsub(/[{}]/, "").to_s
      if i.include?(",")
        min, max = i.split(/,/)
        min = min ? min.to_i : 0
        max = max ? max.to_i : min + 1
        @interval = (min..max).to_a.sample
        max.times do
          @powers_map[:multi] << @candidate.count
        end
      else
        @interval = i.to_i
        @interval.times do
          @powers_map[:multi] << @candidate.count
        end
      end
    end

    def zero_or_more(text)
      more = 2
      more.times do
        @powers_map[:multi] << @candidate.count
      end
      @powers_map[:add] << 1
      @interval = [0, more].sample
    end

    def one_or_more(text)
      more = 2
      more.times do
        @powers_map[:multi] << @candidate.count
      end
      @interval = [1, more].sample
    end

    def zero_or_one(text)
      @powers_map[:multi] << @candidate.count
      @powers_map[:add] << 1
      @interval = [0, 1].sample
    end

    # add candidates
    def literal(text)
      @candidate << text
    end

    def dot(text)
      @candidate += Posix.all - ["\n"]
    end

    def range(text)
      s = text.split(/-/)
      candidate((s[0]..s[1]).to_a)
    end

    def member(text)
      candidate(text.split(//))
    end

    # meta character
    def digit(text) # \d
      candidate(Posix.digit)
    end

    def nondigit(text) # \D
      @negate = true
      candidate(Posix.digit)
    end

    def space(text) # \s
      candidate(Posix.space)
    end

    def nonspace(text) # \S
      @negate = true
      candidate(Posix.space)
    end

    def hex(text) # \h
      candidate(Posix.xdigit)
    end

    def nonhex(text) # \H
      @negate = true
      candidate(Posix.xdigit)
    end

    def word(text) # \w
      candidate(Posix.word)
    end

    def nonword(text) # \W
      @negate = true
      candidate(Posix.word)
    end
  end
end
