module MsgPackRpcClientBase

function to_a(tpl::Tuple, arr = {}, acc = {})
  for t in tpl
    if isa(t, Tuple)
      to_a(t, acc)
    else
      push!(acc, t)
    end
  end
  push!(arr, acc)
  first(arr)
end

end # module MsgPackRpcClientBase
