class Regextruder
  class Meta < Base
    def compile
      @result += @candidate.sample.split(//)
      if @powers_map[:multi].empty? && @powers_map[:add].empty?
        @powers_map[:multi] << @candidate.count
      end
    end
  end
end
