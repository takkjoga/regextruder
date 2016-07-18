require "regexp_parser"
require "regextruder/version"
require "regextruder/base"
require "regextruder/posix"
require "regextruder/escape"
require "regextruder/meta"

class Regextruder
  attr_reader :result, :number_of_ways

  def initialize(result, number_of_ways)
    @result = result
    @number_of_ways = number_of_ways
  end

  class << self
    def generate(pattern)
      pattern = if pattern.kind_of? String
                  Regexp.new(pattern)
                elsif pattern.kind_of? Regexp
                  pattern
                else
                  raise "String or Regexp pattern only"
                end
      result = []
      powers_map = {multi: [], add: []}
      in_group = false
      Regexp::Parser.parse(pattern).traverse do |event, exp|
        #puts "event: #{event}; type: #{exp.type}; #{exp.to_s}"
        if exp.type == :group && [:enter, :exit].include?(event)
          if event == :enter
            k = Regextruder::Group.build(exp.to_s)
            result += k.result
            n = k.powers_map
            powers_map[:multi] += n[:multi]
            powers_map[:add] += n[:add]
            in_group = true
          elsif event == :exit
            in_group = false
          end
        elsif !in_group
          klass = Kernel.const_get("Regextruder::#{exp.type.to_s.capitalize}")
          k = klass.build(exp.to_s)
          result += k.result
          n = k.powers_map
          powers_map[:multi] += n[:multi]
          powers_map[:add] += n[:add]
        end
      end
      number_of_ways = powers_map[:multi].inject(:*) || 0
      number_of_ways += powers_map[:add].inject(0, :+)
      Regextruder.new(result.join, number_of_ways)
    end
  end

  class Type < Base; end

  class Literal < Base; end

  class Group < Base
    def open(text); end
    def capture(text); end
    def close(text); end
  end

  class Anchor < Base
    def bol(text); end
    def eol(text); end
  end

  class Set < Base
    def open(text); end
    def close(text); end

    def method_missing(name, text)
      if name =~ /class_/
        candidate(Posix.send(name.to_s.sub(/class_/, "")))
      elsif name =~ /type_/
        send(name.to_s.sub(/type_/, ""), text)
      end
    end
  end

end
