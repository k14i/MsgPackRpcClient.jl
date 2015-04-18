include("../src/MsgPackRpcClient.jl")

using MsgPackRpcClient

session = MsgPackRpcClient.Session(nothing, nothing, 1)

results = {}

for i in 1:10000
  result = MsgPackRpcClient.call(session, "hello"; sync = true)
  push!(results, result)
end

for result in results
  println(result)
end

close(session.sock)
