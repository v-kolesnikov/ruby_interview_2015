require_relative "../src/find_missing.rb"

describe "find_missing" do
  it { expect(find_missing([])).to eq [] }
  it { expect(find_missing([1, 2, 3, 4])).to eq [] }
  it { expect(find_missing([1, 2, 3, 5])).to eq [4] }
  it { expect(find_missing([1, 3, 4, 5, 6, 8])).to eq [2, 7] }
end
