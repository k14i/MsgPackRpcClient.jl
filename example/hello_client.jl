include("../src/client.jl")

using MsgPackRpcClient

sock = connect(5000)
session = MsgPackRpcClient.Session(sock, 1)

for i in 1:1000
  ret  = MsgPackRpcClient.call(session, "hello")
  println(i, ": ",  ret, ", next_id = ", session.next_id)
#  ret0 = MsgPackRpcClient.call(session, "hello0") |> println
#  ret1 = MsgPackRpcClient.call(session, "hello1") |> println
end

close(sock)
