module GenPrintf
export printf, @fmt_str

abstract type FormatSpecifier end

struct PrintArgument <: FormatSpecifier end
struct PrintValue{V} <: FormatSpecifier end

struct PrintBoth{A,B} <: FormatSpecifier
  a::A
  b::B
end

const ARGN_ERR =
  "wrong number of arguments sent to printf"


include("impl.jl")
include("meta.jl")
include("cons.jl")
include("list.jl")

"""
Macro to create formatting strings.
{} are where arguments will go.

examples:
  fmt"ab cd"
  fmt"hello, {}!"
"""
macro fmt_str(s)
  values = split(unescape_string(s), "{}")
  print_list(values)
end

"""
Prints formatted output. Use the fmt macro for it
to generate code at compile time.

examples:
  printf(fmt"ab cd")
  printf(fmt"hello, {}!", "world")
  printf("ab{}{}", "c", "d")
"""
@generated function printf(fmt::FormatSpecifier, args...)
  printf_impl(fmt, length(args))
end

function printf(fmt::String, args...)
  i = 1
  values = split(fmt, "{}")
  @assert length(values) == length(args)+1 ARGN_ERR

  for value in values
    print(value)
    if i != length(args) + 1
      print(args[i])
      i += 1
    end
  end
end

end

