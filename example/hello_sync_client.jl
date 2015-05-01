include("../src/MsgPackRpcClient.jl")

using MsgPackRpcClient

session = MsgPackRpcClientSession.create() # MsgPackRpcClientSession.Session(nothing, nothing, 1)

the_number_of_call = 10000
results = {}

for i in 1:the_number_of_call
  result = MsgPackRpcClient.call(session, "hello")
  push!(results, result)
end

for result in results
  println(result)
end

session.destroy() # MsgPackRpcClientSession.destroy(session)
