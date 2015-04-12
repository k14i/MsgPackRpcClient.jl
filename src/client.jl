module MsgPackRpcClient

include("sock_pool.jl")

using MsgPack
# using Reactive

export Session, call, MsgPackRpcClientSockPool

const REQUEST  = 0  # [0, msgid, method, param]
const RESPONSE = 1  # [1, msgid, error, result]
const NOTIFY   = 2  # [2, method, param]
const NO_METHOD_ERROR = 0x01
const ARGUMENT_ERROR  = 0x02

const TIMEOUT_IN_SEC = 3

# type Transport
#   address
#   sock_pool :: MsgPackRpcClientSockPool
# end

type Session
  sock          :: Union(Base.TcpSocket, Nothing)
  sock_pool     :: Union(MsgPackRpcClientSockPool.SockPool, Nothing)
  # transport :: Transport
#  auto_coercing :: Bool
#  reqtable      :: Array
  next_id       :: Int
end

type Result
  msg_id :: Int
  result :: Any
  error  :: Any
end

type Future
  timeout :: Any
  loop :: Any
  callback_handler :: Any
  error_handler :: Any
  result_handler :: Any
  is_set :: Bool
  error  :: Any
  result :: Any
  raw :: Any
end

# function coerce_uint()
# end

# Example:
#   s = Session(socket, false, 0)
#   call(s, "get", "foo", 0, [])
function call(s::Session, method::String, params...; sync = false)
  if s.sock_pool == nothing
    s.sock_pool = MsgPackRpcClientSockPool.new()
  end
  if s.sock == nothing
    try
      s.sock = MsgPackRpcClientSockPool.pop(s.sock_pool)
    catch
      MsgPackRpcClientSockPool.add_port(sock_pool)
      s.sock = MsgPackRpcClientSockPool.pop(s.sock_pool)
    end
  # else
  #   MsgPackRpcClientSockPool.push(s.sock_pool, s.sock)
  end

  msg_id = s.next_id
  # For compatibility, msgid must be Int32
  if s.next_id == 1<<31
    s.next_id = 0
  else
    s.next_id += 1
  end

  future = send_request(s.sock, msg_id, method, params)

  if sync == true
    return receive_response(s.sock, msg_id, future)
  else
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
  future = Future(nothing, nothing, nothing, nothing, nothing, false, nothing, nothing, nothing)
end

function send_data(sock::Base.TcpSocket, data)
  write(sock, data)
end

function receive_response(sock::Base.TcpSocket, msg_id::Int, future::Future; timeout = TIMEOUT_IN_SEC, interval = 1)
  unpacked_data = {}

  while 0 <= timeout
    receive_data(sock, future)
    if future.is_set == false
      # println("continue")
      # sleep(1)
      # continue
    end
    unpacked_data = MsgPack.unpack(future.raw)
    if unpacked_data[1] != RESPONSE || unpacked_data[2] != msg_id # type, msgid
println("unpacked_data[2] = ", unpacked_data[2], ", msg_id = ", msg_id)
      timeout -= interval
      sleep(interval)
      continue
    else
      break
    end
    return nothing
  end

  if unpacked_data[3] != nothing  # error
    return unpacked_data[3]
  end

  unpacked_data[4] # result
end

function receive_data(sock::Base.TcpSocket, future::Future)
#  join(sock, future)
  future.raw = readavailable(sock)
  # if length(future.raw) > 0
  #   future.is_set == true
  # end
  # future.raw
end

function join(sock::Base.TcpSocket, future::Future)
  while future.is_set == false
    future.raw = readavailable(sock)
    if length(future.raw) > 0
      future.is_set == true
      break
    end
    sleep(0.1)
    # TODO: Implement timeout
  end
  return future
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
