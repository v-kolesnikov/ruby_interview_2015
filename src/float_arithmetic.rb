require "bigdecimal"

def float_mult(a, b)
  a * b
end

def big_decimal_mult(a, b)
  a * BigDecimal(b.to_s)
end
