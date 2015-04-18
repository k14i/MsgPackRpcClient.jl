include("../src/MsgPackRpcClient.jl")

using MsgPackRpcClient

session = Session(nothing, nothing, 1)

futures = {}

@sync begin
@async for i in 1:10000
  future  = call(session, "hello"; sync = false)
  push!(futures, get(future))
end
end

@sync begin
@async for f in futures
  println(f)
  #println(f.result, ", msg_id = ", f.msg_id, ", is_set = ", f.is_set)
end
end

close(session.sock)
