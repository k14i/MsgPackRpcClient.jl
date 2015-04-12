include("../src/client.jl")

using MsgPackRpcClient

# sock_pool = MsgPackRpcClientSockPool.new()
# typeof(sock_pool) |> println
# MsgPackRpcClientSockPool.add_port(sock_pool, 5000)
# MsgPackRpcClientSockPool.add_port_range(sock_pool, 5000:5000)
# MsgPackRpcClientSockPool.show(sock_pool)
# MsgPackRpcClientSockPool.destroy(sock_pool)
# MsgPackRpcClientSockPool.show(sock_pool)

# s = SockPool().init()
# find(s.pool) |> println
# 
# s.is_empty() |> println
# 
# # s.add(s, 5000:5003)
# # s.is_empty() |> println
# sock = connect(5000)
# s.push(s, sock)
# s.destroy()

# sock = connect(5000)
session = MsgPackRpcClient.Session(nothing, nothing, 1)

# for i in 1:1
#   ret  = MsgPackRpcClient.call(session, "hello"; sync = true)
#   println(i, ": ",  ret, ", next_id = ", session.next_id)
# #  ret0 = MsgPackRpcClient.call(session, "hello0") |> println
# #  ret1 = MsgPackRpcClient.call(session, "hello1") |> println
# end

futures = {}

for i in 1:10
  future  = MsgPackRpcClient.call(session, "hello"; sync = false)
  sleep(0.0375)
  push!(futures, future)
end

for f in futures
  println(f.result, ", msg_id = ", f.msg_id, ", is_set = ", f.is_set)
end

close(session.sock)
