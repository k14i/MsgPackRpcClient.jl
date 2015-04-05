include("../src/client.jl")

using MsgPackRpcClient

sock = connect(5000)
session = MsgPackRpcClient.Session(sock, 0)

ret = MsgPackRpcClient.send_v(session, "hello")

println(ret)

close(sock)
