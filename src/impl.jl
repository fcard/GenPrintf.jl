import Base: @pure

@pure function printf_impl(fmt::Type{PrintArgument}, len, i=1)
  assert_argument_number(len, 1)
  quote
    Base.print(args[$i])
  end
end

@pure assert_argument_number(len, required) =
  @assert len == required ARGN_ERR

@pure function printf_impl(fmt::Type{PrintValue{V}}, len, i=1) where V
  assert_argument_number(len, 0)
  let s = String(V)
    if s == ""
      quote end
    else
      quote
        Base.print($s)
      end
    end
  end
end

@pure function printf_impl(fmt::Type{PrintBoth{A,B}}, len, i=1) where {A,B}
  l1 = arglength(A)
  l2 = arglength(B)
  assert_argument_number(len, l1+l2)

  quote
    $(printf_impl(A, l1, i))
    $(printf_impl(B, l2, i+l1))
  end
end

@pure function printf_impl(fmt::Type{String}, len, i=1) where {A,B}
  :?
end

@pure function arglength(fmt)
  a = Nothing
  b = fmt
  result = 0
  while b <: PrintBoth
    a <: PrintArgument && (result += 1)
    a = b.parameters[1]
    b = b.parameters[2]
  end
  a <: PrintArgument && (result += 1)
  b <: PrintArgument && (result += 1)
  result
end

