module MsgPackRpcClient

using MsgPack
# using Reactive

export Session, SockPool, call

const REQUEST  = 0  # [0, msgid, method, param]
const RESPONSE = 1  # [1, msgid, error, result]
const NOTIFY   = 2  # [2, method, param]
const NO_METHOD_ERROR = 0x01
const ARGUMENT_ERROR  = 0x02

type Session
  sock          :: Base.TcpSocket
#  auto_coercing :: Bool
  next_id       :: Int32
end

type SockPool
  pool     :: Array
  init     :: Function
  is_empty :: Function
  reject!  :: Function
  push     :: Function
  delete   :: Function
  destroy  :: Function

  function SockPool()
    this          = new()
    this.pool     = Union(Base.TcpSocket, Nothing)[]
    this.init     = function() init(this) end
    this.is_empty = function() is_empty(this) end
    this.reject!  = function() reject!(this) end
    this.push     = function() push(this) end
    this.delete   = function() delete(this) end
    this.destroy  = function() destroy(this) end
    this
  end

  function init(self::SockPool)
    self.pool = Union(Base.TcpSocket, Nothing)[]
    self
  end

  function is_empty(self::SockPool)
    if length(self.pool) != 0
      return false
    else
      return true
    end
  end

  function reject!(self::SockPool)
  end

  function push(self::SockPool, sock::Base.TcpSocket)
    push!(self.pool, sock)
    self
  end

  function delete(self::SockPool, sock::Base.TcpSocket)
    i = 1
    for x in self
      if x == sock
        close(self[i])
        self[i] = nothing
      end
      i += 1
    end
    self
  end

  function destroy(self::SockPool)
    for x in self
      if x == nothing
        continue
      end
      close(x)
    end
    nothing
  end
end

type Result
  msg_id :: Int32
  result :: Any
  error  :: Any
end

type Future
  is_set :: Bool
  error  :: Any
  result :: Any
end

# function coerce_uint()
# end

# Example:
#   s = Session(socket, false, 0)
#   call(s, "get", "foo", 0, [])
function call(s::Session, method::String, params...)
  msg_id = s.next_id
  if s.next_id == 1<<31
    s.next_id = 0
  else
    s.next_id += 1
  end
  send_request(s.sock, msg_id, method, params)
  receive_response(s.sock, msg_id)
end

function send_request(sock::Base.TcpSocket, msg_id::Int32, method::String, args)
  params = {}  # NOTE: Equal to ```params = Any[]```, which can grow.
  for x in args
    push!(params, x)
  end
  packed_data = MsgPack.pack([REQUEST, msg_id, method, params])
  send_data(sock, packed_data)
end

function send_data(sock::Base.TcpSocket, data)
  # TODO: Use sockpool
  write(sock, data)
end

function receive_response(sock::Base.TcpSocket, msg_id::Int32)
  future = Future(false, nothing, nothing)
  packed_data = receive_data(sock, future)
  if future.is_set == false
  end
  unpacked_data = MsgPack.unpack(packed_data)
  # TODO: Error handlings
  if unpacked_data[1] != RESPONSE  # type
  end
  if unpacked_data[2] != msg_id # msgid
  end
  if unpacked_data[3] != nothing  # error
  end
  if length(unpacked_data[4]) == 0  # result
  end
  unpacked_data[4]
end

function receive_data(sock::Base.TcpSocket, future::Future)
#  data = join(sock, future)
  data = readavailable(sock)
end

function join(sock::Base.TcpSocket, future::Future)
  while future.is_set == false
    data = readavailable(sock)
    if length(data) > 0
      future.is_set == true
      return data
    end
    sleep(0.1)
    # TODO: Implement timeout
  end
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
