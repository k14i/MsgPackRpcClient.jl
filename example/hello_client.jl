include("../src/client.jl")

using MsgPackRpcClient

sock = connect(5000)
session = MsgPackRpcClient.Session(sock, 0)

MsgPackRpcClient.send_v(session, "hello")

close(sock)
