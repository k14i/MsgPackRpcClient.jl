module MsgPackRpcClient

include("const.jl")
include("sock_pool.jl")
include("session.jl")
include("future.jl")

using MsgPack

export MsgPackRpcClientSession, call, get #, MsgPackRpcClientSockPool

# type Transport
#   address
#   sock_pool :: MsgPackRpcClientSockPool
# end

function call(s::MsgPackRpcClientSession.Session, method::String, params...; sync = true)
  if s.sock_pool == nothing
    s.sock_pool = MsgPackRpcClientSockPool.new()
  end
  if s.sock == nothing
    try
      s.sock = MsgPackRpcClientSockPool.pop!(s.sock_pool)
    catch
      MsgPackRpcClientSockPool.connect_and_push!(sock_pool)
      s.sock = MsgPackRpcClientSockPool.pop!(s.sock_pool)
    end
  end

  msg_id = s.next_id
  # NOTE: For compatibility, msgid must be Int32
  if s.next_id == 1<<31
    s.next_id = 0
  else
    s.next_id += 1
  end

  future = send_request(s.sock, msg_id, method, params)

  if sync == true
    receive_response(s.sock, future)
    return get(future)
  else
    future.task = @async receive_response(s.sock, future)
    return future
  end
end

function send_request(sock::Base.TcpSocket, msg_id::Int, method::String, args)
  params = {}  # NOTE: Equal to ```params = Any[]```, which can grow.
  for x in args
    push!(params, x)
  end
  packed_data = MsgPack.pack([REQUEST, msg_id, method, params])
  send_data(sock, packed_data)
  Future(TIMEOUT_IN_SEC, nothing, nothing, nothing, false, nothing, nothing, nothing, msg_id, nothing)
end

function send_data(sock::Base.TcpSocket, data)
  write(sock, data)
  nothing
end

function get(future::Future)
  if future.task != nothing
    wait(future.task)
  end
  if future.error == nothing
    # if future.result_handler != nothing
    #   return result_handler.call()
    # end
    return future.result
  end
  if future.result == nothing
    # TODO: raise instead of return
    return nothing
  end
  # if future.error_handler != nothing
  #   return error_handler.call()
  # end
  # TODO: raise instead of return
  nothing
end

function receive_response(sock::Base.TcpSocket, future::Future; interval = 1)
  unpacked_data = {}
  timeout = future.timeout

  while 0 <= timeout
    receive_data(sock, future)
    if future.is_set == false
      # println("continue")
      # sleep(1)
      # continue
    end
    unpacked_data = MsgPack.unpack(future.raw)
    if unpacked_data[1] != RESPONSE || unpacked_data[2] != future.msg_id # type, msgid
      timeout -= interval
      sleep(interval)
      continue
    else
      break
    end
    return nothing
  end

  if unpacked_data[3] != nothing  # error
    future.error = unpacked_data[3]
  end

  if unpacked_data[4] != nothing #result
    future.result = unpacked_data[4]
  end

  future
end

function receive_data(sock::Base.TcpSocket, future::Future)
  join(sock, future)
  nothing
end

function join(sock::Base.TcpSocket, future::Future; interval = 1)
  timeout = future.timeout
  while future.is_set == false && timeout > 0
    future.raw = readavailable(sock)
    if length(future.raw) > 0
      future.is_set = true
      break
    end
    sleep(interval)
    timeout -= interval
  end
  future
end

end # module client


# module client
# 
# export Client
# 
# type Client
#   address::String
#   timeout::Int
#   loop::Bool
#   builder::String
#   reconnect_limit::Int
#   pack_encoding::String
#   unpack_encoding::String
#   init::Function
#   open::Function
# 
#   function Client(address, timeout, loop, builder, reconnect_limit, pack_encoding, unpack_encoding)
#     this = new()
#     this.address = address
#     this.timeout = timeout
#     this.loop = loop
#     this.builder = builder
#     this.reconnect_limit = reconnect_limit
#     this.pack_encoding = pack_encoding
#     this.unpack_encoding = unpack_encoding
# 
#     this.init = function() init(this) end
#     this.open = function() open(args) end
# 
#     this
#   end
# 
#   function init(self::Client)
#   end
# 
#   function open(args)
#     client = Client(args)
#     return Client.Context(client)
#   end
# 
#   type Context(object)
#     client::Client
#     init::Function
#     enter::Function
#     exit::Function
# 
#     function Context()
#       this = new()
#       this.init = function() init(this, client) end
#       this.enter = function() enter(this) end
#       this.exit = function() exit(this, _type, value, traceback) end
# 
#       this
#     end
# 
#     function init(self::Context, client::Client)
#       self._client = client
#     end
# 
#     function enter(self::Context)
#       return self._client
#     end
# 
#     function exit(self::Context, _type::String, value::String, traceback::String)
#       self.client.close()
#       if _type
#         return false
#       end
#       return true
#     end
# 
#   end
# end
# 
# # const PORT = 5000
# 
# # function connect()
# #   connect(PORT)
# # end
# 
# # function send()
# #   return sendv()
# # end
# 
# # function sendv()
# 
# # end
# 
# end # module client
