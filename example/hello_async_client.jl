include("../src/MsgPackRpcClient.jl")

using MsgPackRpcClient

session = MsgPackRpcClientSession.create()

the_number_of_call = 10000
results = {}

@sync begin
@async for i in 1:the_number_of_call
  future = call(session, "hello"; sync = false)
  push!(results, get(future))
end
end

@sync begin
@async for r in results
  println(r)
end
end

session.destroy()
