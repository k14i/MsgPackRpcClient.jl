module MsgPackClient

using MsgPack

const REQUEST  = 0  # [0, msgid, method, param]
const RESPONSE = 1  # [1, msgid, error, result]
const NOTIFY   = 2  # [2, method, param]
const NO_METHOD_ERROR = 0x01
const ARGUMENT_ERROR  = 0x02

type Session
  conn          :: Base.TcpSocket
  auto_coercing :: Bool
  next_id       :: Int32
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

function coerce_uint()
end

# Example:
#   s = Session(socket, false, 0)
#   send_v(s, "get", "foo", 0, [])
function send_v(self::Session, func_name::String, args...)
  msg_id = self.next_id
  if self.next_id == 1<<31
    self.next_id = 0
  else
    self.next_id += 1
  end
  send_request(msg_id, func_name, args)
  receive_response()
end

function send_request(msg_id::Int32, func_name::String, args...)
  packed_data = MsgPack.pack([REQUEST, msg_id, func_name, args])
  send_data(packed_data)
end

function send_data(data)
  # TODO: Use sockpool
  write(sock, data)
end

function receive_response()
  packed_data = receive_data()
  MsgPack.unpack(packed_data)
end

function receive_data()
  read(sock)
end

function join(future::Future)
  while future.is_set == false
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
