include("../src/client.jl")

using MsgPackRpcClient

session = MsgPackRpcClient.Session(nothing, nothing, 1)

futures = {}

@sync begin
@async for i in 1:10000
  future  = MsgPackRpcClient.call(session, "hello"; sync = false)
  push!(futures, MsgPackRpcClient.get(future, target = :result))
end
end

@sync begin
@async for f in futures
  println(f)
  #println(f.result, ", msg_id = ", f.msg_id, ", is_set = ", f.is_set)
end
end

close(session.sock)
