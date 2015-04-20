include("../src/MsgPackRpcClient.jl")

using MsgPackRpcClient

session = MsgPackRpcClientSession.create()
MsgPackRpcClientSession.create_sock(session, "localhost", 5000)
MsgPackRpcClientSession.create_sock(session, "localhost", 5001)
MsgPackRpcClientSession.create_sock(session, "localhost", 5002)

futures = {}

@sync begin
@async for i in 1:10000
  future  = call(session, "hello"; sync = false)
  push!(futures, get(future))
  MsgPackRpcClientSession.rotate(session)
end
end

@sync begin
@async for f in futures
  println(f)
end
end

session.destroy()
