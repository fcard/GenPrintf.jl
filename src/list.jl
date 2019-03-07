import Base: @pure

@pure function print_list(values)
  argument()  = PrintArgument()
  to_value(x) = PrintValue{Symbol(String(x))}()

  if length(values) == 1
    to_value(values[1])
  else
    if values[1] == ""
      PrintBoth(
        argument(),
        print_list(values[2:end])
      )
    else
      PrintBoth(
        to_value(values[1]),
        print_list([""; values[2:end]])
      )
    end
  end
end

