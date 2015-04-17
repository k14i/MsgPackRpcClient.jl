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

# for i in 1:100000
#   ret  = MsgPackRpcClient.call(session, "hello"; sync = true)
# #  println(i, ": ",  ret, ", next_id = ", session.next_id)
# #  ret0 = MsgPackRpcClient.call(session, "hello0") |> println
# #  ret1 = MsgPackRpcClient.call(session, "hello1") |> println
# end

futures = {}

@sync begin
@async for i in 1:1000
#  @sync begin
#  @async begin
  future  = MsgPackRpcClient.call(session, "hello"; sync = false)
#  sleep(0.0375)
#  sleep(0.1)
  wait(future.task)
  push!(futures, future)
#  end
#  end
end
end

#sleep(5)

@sync begin
@async for f in futures
  wait(f.task)
#  println(f.task)

  #if f.result == nothing
#  if f.is_set == true
    println(f.result, ", msg_id = ", f.msg_id, ", is_set = ", f.is_set)
#  end
end
end

close(session.sock)
