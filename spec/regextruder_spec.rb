require "spec_helper"
require "regextruder"

describe Regextruder do
  it "has a version number" do
    expect(Regextruder::VERSION).not_to be nil
  end
  describe "#generate" do
    describe "result" do
      context "POSIX bracket expressions" do
        it { expect(Regextruder.generate("[[:alnum:]]").result).to match(/[[:alnum:]]/) }
        it { expect(Regextruder.generate("[[:digit:]]").result).to match(/[[:digit:]]/) }
        it { expect(Regextruder.generate("[[:space:]]").result).to match(/[[:space:]]/) }
        it { expect(Regextruder.generate("[[:word:]]").result).to match(/[[:word:]]/) }
        it { expect(Regextruder.generate("[[:lower:]]").result).to match(/[[:lower:]]/) }
        it { expect(Regextruder.generate("[[:upper:]]").result).to match(/[[:upper:]]/) }
        it { expect(Regextruder.generate("[[:alpha:]]").result).to match(/[[:alpha:]]/) }
        it { expect(Regextruder.generate("[[:blank:]]").result).to match(/[[:blank:]]/) }
        it { expect(Regextruder.generate("[[:cntrl:]]").result).to match(/[[:cntrl:]]/) }
        it { expect(Regextruder.generate("[[:graph:]]").result).to match(/[[:graph:]]/) }
        it { expect(Regextruder.generate("[[:print:]]").result).to match(/[[:print:]]/) }
        it { expect(Regextruder.generate("[[:punct:]]").result).to match(/[[:punct:]]/) }
        it { expect(Regextruder.generate("[[:xdigit:]]").result).to match(/[[:xdigit:]]/) }
      end

      context "metacharacters" do
        it { expect(Regextruder.generate(".").result).to match(/./) }
        it { expect(Regextruder.generate(".").result).not_to match(/\n/) }
        it { expect(Regextruder.generate("\\d").result).to match(/\d/) }
        it { expect(Regextruder.generate("\\D").result).to match(/\D/) }
        it { expect(Regextruder.generate("\\s").result).to match(/\s/) }
        it { expect(Regextruder.generate("\\S").result).to match(/\S/) }
        it { expect(Regextruder.generate("\\h").result).to match(/\h/) }
        it { expect(Regextruder.generate("\\H").result).to match(/\H/) }
        it { expect(Regextruder.generate("\\w").result).to match(/\w/) }
        it { expect(Regextruder.generate("\\W").result).to match(/\W/) }
      end

      context "repeat" do
        it { expect(Regextruder.generate(".*").result).to match(/.*/) }
        it { expect(Regextruder.generate(".+").result).to match(/.+/) }
        it { expect(Regextruder.generate("a*").result).to match(/a*/) }
        it { expect(Regextruder.generate("a+").result).to match(/a+/) }
        it { expect(Regextruder.generate("a?").result).to match(/a?/) }
        it { expect(Regextruder.generate("a{1,}").result).to match(/a{1,}/) }
        it { expect(Regextruder.generate("a{,1}").result).to match(/a{,1}/) }
        it { expect(Regextruder.generate("a{1,2}").result).to match(/a{1,2}/) }
        it { expect(Regextruder.generate("a{3}").result).to match(/a{3}/) }
      end

      context "group" do
        it { expect(Regextruder.generate("(abc|def)").result).to match(/(abc|def)/) }
        it { expect(Regextruder.generate("(abc|def|ghi)").result).to match(/(abc|def|ghi)/) }
      end

      context "various" do
        it { expect(Regextruder.generate("\\d+\\.\\d+").result).to match(/\d+\.\d+/) }
        it { expect(Regextruder.generate("\\d+(\\.\\d+)?").result).to match(/\d+(\.\d+)?/) }
        it { expect(Regextruder.generate("[\\d,]+(\\.\\d+)?").result).to match(/[\d,]+(\.\d+)?/) }
        it { expect(Regextruder.generate("\\d{4}/\\d{1,2}/\\d{1,2}").result).to match(/\d{4}\/\d{1,2}\/\d{1,2}/) }
        it { expect(Regextruder.generate("[0-9]{2}-[a-z]{5}-[A-Z]{3}").result).to match(/[0-9]{2}-[a-z]{5}-[A-Z]{3}/) }
        it { expect(Regextruder.generate("[\\w\\d_-]+@[\\w\\d_-]+\\.[\\w\\d._-]+").result).to match(/[\w\d_-]+@[\w\d_-]+\.[\w\d._-]+/) }
        it { expect(Regextruder.generate("^[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@[a-zA-Z0-9_-]+\\.[a-zA-Z]{2,4}$").result).to match(/^[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@[a-zA-Z0-9_-]+\.[a-zA-Z]{2,4}$/) }
        it { expect(Regextruder.generate("http://[\\w\\d/%#$&?()~_.=+-]+").result).to match(/http:\/\/[\w\d\/%#$&?()~_.=+-]+/) }
      end
    end

    describe "number_of_ways" do
      it { expect(Regextruder.generate(".").number_of_ways).to eq 0x7f - 1 }
      it { expect(Regextruder.generate(".?").number_of_ways).to eq 0x7f - 1 + 1 }
      it { expect(Regextruder.generate(".*").number_of_ways).to eq (0x7f - 1) ** 2 + 1 }
      it { expect(Regextruder.generate(".+").number_of_ways).to eq (0x7f - 1) ** 2 }
      it { expect(Regextruder.generate("[0-9]..[0-9]").number_of_ways).to eq 10 * ((0x7f - 1) ** 2) * 10 }
      it { expect(Regextruder.generate("[0-9].{3}[0-9]").number_of_ways).to eq 10 * ((0x7f - 1) ** 3) * 10 }
      it { expect(Regextruder.generate("(abc|def)").number_of_ways).to eq 2 }
      it { expect(Regextruder.generate("(abc|def|ghi)").number_of_ways).to eq 3 }
      it { expect(Regextruder.generate("(abc|def|ghi)jkl").number_of_ways).to eq 3 }
      it { expect(Regextruder.generate("890(abc|def|ghi)jkl").number_of_ways).to eq 3 }
    end
  end
end
