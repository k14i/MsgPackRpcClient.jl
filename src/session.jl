module MsgPackRpcClientSession

include("sock_pool.jl")
include("const.jl")

# TODO: Unite sock and sock_pool
type Session
  sock      :: Union(Base.TcpSocket, Base.UdpSocket, Nothing)
  sock_pool :: MsgPackRpcClientSockPool.SockPool
  next_id   :: Int

  create        :: Function
  destroy       :: Function
  set_sock      :: Function
  set_sock_pool :: Function
  set_next_id   :: Function
  get_sock      :: Function
  get_sock_pool :: Function
  get_next_id   :: Function
  rotate        :: Function

  function Session(sock = nothing, sock_pool = MsgPackRpcClientSockPool.SockPool({}), next_id = 1)
    this           = new()
    this.sock      = sock
    this.sock_pool = sock_pool
    this.next_id   = next_id
    this.create        = function() create(sock, sock_pool, next_id) end
    this.destroy       = function() destroy(this) end
    this.set_sock      = function() set_sock(this, sock) end
    this.set_sock_pool = function() set_sock_pool(this, sock_pool) end
    this.set_next_id   = function() set_next_id(this, next_id) end
    this.get_sock      = function() get_sock(this) end
    this.get_sock_pool = function() get_sock_pool(this) end
    this.get_next_id   = function() get_next_id(this) end
    this.rotate        = function() rotate(this) end
    this
  end
end

function create(sock = nothing,
                sock_pool::MsgPackRpcClientSockPool.SockPool = MsgPackRpcClientSockPool.SockPool({}),
                next_id = 1)
  Session(sock, sock_pool, next_id)
end

function destroy(self::Session)
  try
    if self.sock != nothing
      close(self.sock)
    end
    if self.sock_pool != {}
      MsgPackRpcClientSockPool.destroy(self.sock_pool)
    end
    next_id = 1
  catch
    return false
  end
  true
end

function set_sock(self::Session, sock::Union(Base.TcpSocket, Base.UdpSocket, Nothing))
  self.sock = sock
  self
end

function set_sock_pool(self::Session, sock_pool::Any)
  self.sock_pool = sock_pool
  self
end

function set_next_id(self::Session, next_id::Int)
  self.next_id = next_id
  self
end

function get_sock(self::Session)
  self.sock
end

function get_sock_pool(self::Session)
  self.sock_pool
end

function get_next_id(self::Session)
  self.next_id
end

function create_sock(self::Session, host::String = "localhost", port::Int = DEFAULT_PORT_NUMBER)
  sock = connect(host, port)
  if self.sock == nothing
    self.sock = sock
  else
    MsgPackRpcClientSockPool.enqueue!(self.sock_pool, sock)
  end
  self
end

# TODO: Use pointer
function rotate(self::Session)
  MsgPackRpcClientSockPool.enqueue!(self.sock_pool, self.sock)
  self.sock = MsgPackRpcClientSockPool.dequeue!(self.sock_pool)
  self
end

end # module MagPackRpcClientSession


# module session
# 
# export Session
# 
# type Loop end
# type Tcp end
# type Method end
# type Reason end
# type Error end
# type Result end
# 
# type Session
#   address::String
#   timeout::Int
# #  loop::Loop
# #  builder::Tcp
#   reconnect_limit::Int
#   pack_encoding::String
#   unpack_encoding::String
# 
#   call::Function
#   call_async::Function
#   send_request::Function
#   notify::Function
#   close::Function
#   on_connect_failed::Function
#   on_response::Function
#   on_timeout::Function
#   step_timeout::Function
#   NoSyncIDGenerator::Function
# 
#   request_table::Array
# 
#   function Session(address, timeout, loop, builder, reconnect_limit, pack_encoding, unpack_encoding)
#     this                   = new()
#     this.address           = address
#     this.timeout           = timeout
# #    this.loop              = loop
# #    this.builder           = builder
#     this.reconnect_limit   = reconnect_limit
#     this.pack_encoding     = pack_encoding
#     this.unpack_encoding   = unpack_encoding
# 
#     this.call              = function() call(this, method, args) end
#     this.call_async        = function() call_async(this, method, args) end
#     this.send_request      = function() send_request(this, method, args) end
#     this.notify            = function() notify(this, method, args) end
#     this.close             = function() close(this) end
#     this.on_connect_failed = function() on_connect_failed(self, reason) end
#     this.on_response       = function() on_response(self, msgid, error, result) end
#     this.on_timeout        = function() on_timeout(self, msgid) end
#     this.step_timeout      = function() step_timeout(self) end
#     this.generator         = function() NoSyncIDGenerator() end
# 
#     this.request_table     = []
# 
#     this
#   end
# 
#   function call(self::Session, method::Method, args::Array)
#     # return self.send_request(method, args).get()
#   end
# 
#   function call_async(self::Session, method::Method, args::Array)
#     # return self.send_request(method, args)
#   end
# 
#   function send_request(self::Session, method::Method, args::Array)
#     # msgid = next(self.generator)
#     # future = Future(self.loop, self.timeout)
#     # self.request_table[msgid] = future
#     # self.transport.send_message([message.REQUEST, msgid, method, args])
#     # return future
#   end
# 
#   function notify(self::Session, method::Method, args::Array)
#     # function callback
#     #   self.loop.stop()
#     # end
#     # self.transport.send_message([message.NOTIFY, method, args], callback = callback)
#     # self.loop.start()
#   end
# 
#   function close(self::Session)
#     # if self.transport
#     #   self.transport.close()
#     # end
#     # self.transport = nothing
#     # self.request_table = {}
#   end
# 
#   function on_connect_failed(self::Session, reason::Reason)
#   end
# 
#   function on_response(self::Session, msgid::Int, error::Error, result::Result)
#     # if not msgid in self._request_table
#     #     return
#     # end
#     # future = self.request_table.pop(msgid)
# 
#     # if error is not nothing
#     #   future.set_error(error)
#     # else
#     #   future.set_result(result)
#     # end
#     # self.loop.stop()
#   end
# 
#   function on_timeout(self::Session, msgid::Int)
#     # future = self.request_table.pop(msgid)
#     # future.set_error("Request timed out")
#   end
# 
#   function step_timeout(self::Session)
#   end
# 
#   function NoSyncIDGenerator()
#     counter = 0
#     while true
#       counter += 1
#       if counter > (1 << 30)
#         counter = 0
#         break
#       end
#     end
#     return counter
#   end
# 
# end
# 
# end # module session
