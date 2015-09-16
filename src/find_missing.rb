def find_missing(a, offset = 1)
  a.sort.each.with_index.with_object([]) do |(item, index), missing|
    diff = item - index
    if diff > offset
      (diff - offset).downto(1).each { |d| missing << item - d }
      offset = diff
    end
  end
end
