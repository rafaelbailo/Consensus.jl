macro isCalledFromFunction()
  expr = esc(:(
    try
      currentFunctionName = nameof(var"#self#")
      true
    catch
      false
    end
  ))
  return expr
end

macro isAllocationFree(expr...)
  return esc(
    quote
      !@isCalledFromFunction() &&
        @warn "@isAllocationFree could be imprecise if evaluated outside a function"
      (@allocated $(expr...)) === 0
    end,
  )
end
