def find_missing(a)
  offset = 1
  missing = []
  a.sort.each_with_index do |item, index|
    diff = item - index
    if diff > offset
      missing << item - 1
      offset = diff
    end
  end
  missing
end
