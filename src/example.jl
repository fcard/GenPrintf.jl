function p(fmt, list)
  i = 1
  while i < length(list)
    printf(fmt, list[i])
    i += 1
  end
end
