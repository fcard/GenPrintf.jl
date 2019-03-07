"""
exports @printf_code and printf_code, which returns
the code generated for printf.
"""
module Meta
export @printf_code, printf_code
import Base: @pure
import ..GenPrintf: printf_impl

"""
returns the code that printf will generate.
e.g. `@printf_code(fmt"abc")` will return
```
quote
    print("abc")
end
```

"""
macro printf_code(fmt, args...)
  quote
    flatten_body(
      remove_line_nodes(
        printf_impl(
          typeof($(esc(fmt))),
          $(length(args))
        )
      )
    )
  end
end

"""
returns the code that printf will generate.
e.g. `printf_code(fmt"abc")` will return
```
quote
    print("abc")
end
```
"""
@pure function printf_code(fmt, args...)
  flatten_body(
    remove_line_nodes(
      printf_impl(
        typeof(fmt),
        length(args)
      )
    )
  )
end

@pure remove_line_nodes(x) = x

@pure function remove_line_nodes(x::Expr)
  Expr(
    x.head,
    map(
      remove_line_nodes,
      filter(!x->x isa LineNumberNode, x.args)
    )...
  )
end

@pure flatten_body(x) = x

@pure function flatten_body(x::Expr)
  result_args = []

  for arg in x.args
    if arg isa Expr && arg.head == :block
      append!(result_args, flatten_body(arg).args)
     else
      push!(result_args, arg)
    end
  end

  Expr(:block, result_args...)
end

end
