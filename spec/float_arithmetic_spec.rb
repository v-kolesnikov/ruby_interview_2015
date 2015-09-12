require_relative "../src/float_arithmetic.rb"

describe "Float arithmetic" do
  let(:a) { 24.0 }
  let(:b) { 0.1 }

  it "floating arithmetic" do
    expect(float_mult(a, b)).to eq 2.4000000000000004
  end

  it "big decimal arithmetic" do
    expect(big_decimal_mult(a, b)).to eq 2.4
  end
end
