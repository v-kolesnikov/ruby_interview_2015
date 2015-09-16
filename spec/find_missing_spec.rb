require_relative "../src/find_missing.rb"

describe "find_missing" do
  it { expect(find_missing([])).to eq [] }
  it { expect(find_missing([1, 2, 3, 4])).to eq [] }
  it { expect(find_missing([1, 2, 3, 5])).to eq [4] }
  it { expect(find_missing([1, 3, 4, 6])).to eq [2, 5] }
  it { expect(find_missing([1, 2, 3, 6])).to eq [4, 5] }
  it { expect(find_missing([1, 4, 5, 8])).to eq [2, 3, 6, 7] }
  it { expect(find_missing([3, 4, 5, 8])).to eq [1, 2, 6, 7] }

  context "with offset" do
    it { expect(find_missing([4, 5, 6, 8], 4)).to eq [7] }
    it { expect(find_missing([4, 5, 6, 9], 4)).to eq [7, 8] }
    it { expect(find_missing([4, 7, 8, 11], 4)).to eq [5, 6, 9, 10] }
  end
end
