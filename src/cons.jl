"""
exports fmt and @fmt, functions to build
format specifiers in an alternate
way to @fmt_str
"""
module Cons
export fmt, @fmt
import Base: @pure
import ..GenPrintf: PrintArgument, PrintValue,
                    PrintBoth, FormatSpecifier

"""
builds format specifiers.
examples:
  @fmt("abc")
  @fmt("hello, ", {})
"""
macro fmt(args...)
  fmt(args...)
end

"""
builds format specifiers.
examples:
  fmt("abc")

  a = "hello, "
  fmt(a, :{})
"""
@pure function fmt(literal::Union{Number, String})
  PrintValue{Symbol(String(literal))}()
end

@pure function fmt(ex::Expr)
  if ex.head == :tuple
    fmt(ex.args...)
  else
    @assert ex == :{} "invalid formatting expression"
    PrintArgument()
  end
end

@pure function fmt(ex::Tuple)
  fmt(args...)
end

@pure function fmt(ex::FormatSpecifier)
  ex
end

@pure function fmt(args...)
  PrintBoth(fmt(args[1]), fmt(args[2:end]...))
end

end

