class Regextruder
  class Escape < Base
    def build; end
    def compile
      @result += [@pattern[1]]
    end
  end
end
