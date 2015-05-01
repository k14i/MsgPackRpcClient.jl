include("../src/MsgPackRpcClient.jl")

using MsgPackRpcClient

session = MsgPackRpcClientSession.create()
MsgPackRpcClientSession.create_sock(session, "localhost", 5000)
MsgPackRpcClientSession.create_sock(session, "localhost", 5001)
MsgPackRpcClientSession.create_sock(session, "localhost", 5002)

the_number_of_call = 10000
results = {}

@sync begin
@async for i in 1:the_number_of_call
  future  = call(session, "hello"; sync = false, sock = session.socks.pool[session.ptr])
  push!(results, get(future))
  MsgPackRpcClientSession.rotate(session)
end
end

@sync begin
@async for r in results
  println(r)
end
end

session.destroy()
