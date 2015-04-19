include("../src/MsgPackRpcClient.jl")

using MsgPackRpcClient

session = MsgPackRpcClientSession.create() # MsgPackRpcClientSession.Session(nothing, nothing, 1)

results = {}

for i in 1:10000
  result = MsgPackRpcClient.call(session, "hello")
  push!(results, result)
end

for result in results
  println(result)
end

session.destroy() # MsgPackRpcClientSession.destroy(session)
