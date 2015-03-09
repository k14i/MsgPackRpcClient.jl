module session

type Loop end
type Tcp end
type Method end
type Reason end
type Error end
type Result end

type Session
  address::String
  timeout::Int
#  loop::Loop
#  builder::Tcp
  reconnect_limit::Int
  pack_encoding::String
  unpack_encoding::String

  call::Function
  call_async::Function
  send_request::Function
  notify::Function
  close::Function
  on_connect_failed::Function
  on_response::Function
  on_timeout::Function
  step_timeout::Function

  function Session(address, timeout, loop, builder, reconnect_limit, pack_encoding, unpack_encoding)
    this                   = new()
    this.address           = address
    this.timeout           = timeout
#    this.loop              = loop
#    this.builder           = builder
    this.reconnect_limit   = reconnect_limit
    this.pack_encoding     = pack_encoding
    this.unpack_encoding   = unpack_encoding

    this.call              = function() call(this, method, args) end
    this.call_async        = function() call_async(this, method, args) end
    this.send_request      = function() send_request(this, method, args) end
    this.notify            = function() notify(this, method, args) end
    this.close             = function() close(this) end
    this.on_connect_failed = function() on_connect_failed(self, reason) end
    this.on_response       = function() on_response(self, msgid, error, result) end
    this.on_timeout        = function() on_timeout(self, msgid) end
    this.step_timeout      = function() step_timeout(self) end

    this
  end

  function call(self::Session, method::Method, args::Array)
    # return self.send_request(method, args).get()
  end

  function call_async(self::Session, method::Method, args::Array)
    # return self.send_request(method, args)
  end

  function send_request(self::Session, method::Method, args::Array)
    # msgid = next(self.generator)
    # future = Future(self.loop, self.timeout)
    # self.request_table[msgid] = future
    # self.transport.send_message([message.REQUEST, msgid, method, args])
    # return future
  end

  function notify(self::Session, method::Method, args::Array)
    # function callback
    #   self.loop.stop()
    # end
    # self.transport.send_message([message.NOTIFY, method, args], callback = callback)
    # self.loop.start()
  end

  function close(self::Session)
    # if self.transport
    #   self.transport.close()
    # end
    # self.transport = nothing
    # self.request_table = {}
  end

  function on_connect_failed(self::Session, reason::Reason)
  end

  function on_response(self::Session, msgid::Int, error::Error, result::Result)
  end

  function on_timeout(self::Session, msgid::Int)
  end

  function step_timeout(self::Session)
  end

  function NoSyncIDGenerator()
  end

end

end # session
