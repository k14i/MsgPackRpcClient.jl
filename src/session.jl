module MsgPackRpcClientSession

include("socks.jl")
include("const.jl")

type Session
  socks   :: MsgPackRpcClientSocks.Socks
  ptr     :: Int
  next_id :: Int

  create      :: Function
  destroy     :: Function
  set_socks   :: Function
  set_ptr     :: Function
  set_next_id :: Function
  get_sock    :: Function
  get_socks   :: Function
  get_ptr     :: Function
  get_next_id :: Function
  rotate      :: Function

  function Session(socks = MsgPackRpcClientSocks.Socks({}), ptr = 0, next_id = 1)
    this         = new()
    this.socks   = socks
    this.ptr     = ptr
    this.next_id = next_id
    this.create      = function() create(socks, next_id) end
    this.destroy     = function() destroy(this) end
    this.set_socks   = function() set_socks(this, socks) end
    this.set_ptr     = function() set_ptr(this, ptr) end
    this.set_next_id = function() set_next_id(this, next_id) end
    this.get_sock    = function() get_sock(this) end
    this.get_socks   = function() get_socks(this) end
    this.get_ptr     = function() get_ptr(this) end
    this.get_next_id = function() get_next_id(this) end
    this.rotate      = function() rotate(this) end
    this
  end
end

function create(socks::MsgPackRpcClientSocks.Socks = MsgPackRpcClientSocks.Socks({}),
                ptr = 0,
                next_id = 1)
  Session(socks, ptr, next_id)
end

function destroy(self::Session)
  try
    if length(self.socks.pool) > 0
      MsgPackRpcClientSocks.destroy(self.socks)
    end
    self.ptr = 1
    self.next_id = 1
  catch
    return false
  end
  true
end

function set_socks(self::Session, socks::Any)
  self.socks = socks
  self
end

function set_ptr(self::Session, ptr::Int)
  self.ptr = ptr
  self
end

function set_next_id(self::Session, next_id::Int)
  self.next_id = next_id
  self
end

function get_sock(self::Session)
  self.socks.pool[self.ptr]
end

function get_socks(self::Session)
  self.socks
end

function get_ptr(self::Session)
  self.ptr
end

function get_next_id(self::Session)
  self.next_id
end

function create_sock(self::Session, host::String = DEFAULT_HOST, port::Int = DEFAULT_PORT_NUMBER)
  sock = connect(host, port)
  MsgPackRpcClientSocks.enqueue!(self.socks, sock)
  if self.ptr == 0
    self.ptr = 1
  end
  self
end

function rotate(self::Session)
  if self.ptr == 0
    # TODO: raise
  end
  self.ptr = self.ptr + 1 > length(self.socks.pool) ? 1 : self.ptr + 1
  self.socks.pool[self.ptr]
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
