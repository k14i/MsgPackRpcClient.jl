module MsgPackRpcClientSession

include("sock_pool.jl")

type Session
  sock      :: Union(Base.TcpSocket, Nothing)
  sock_pool :: Any #Union(MsgPackRpcClientSockPool.SockPool, Nothing)
  next_id   :: Int

  create    :: Function
  destroy   :: Function

  function Session(sock, sock_pool, next_id)
    this           = new()
    this.sock      = sock
    this.sock_pool = sock_pool
    this.next_id   = next_id
    this.create    = function() create() end
    this.destroy   = function() destroy(this) end
    this
  end
end

function create()
  Session(nothing, nothing, 1)
end

function destroy(self::Session)
  try
    if self.sock != nothing
      close(self.sock)
    end
    if self.sock_pool != nothing
      MsgPackRpcClientSockPool.destroy(self.sock_pool)
    end
    next_id = 1
  catch
    return false
  end
  true
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
