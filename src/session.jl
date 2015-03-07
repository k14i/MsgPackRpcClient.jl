module session

type Session
  address::String
  timeout::Int
  loop::Loop
  builder::Tcp
  reconnect_limit::Int
  pack_encoding::String
  unpack_encoding::String

  function Session(session::Session)
    this                 = new()
    this.address         = session.address
    this.timeout         = session.timeout
    this.loop            = session.loop
    this.builder         = session.builder
    this.reconnect_limit = session.reconnect_limit
    this.pack_encoding   = session.pack_encoding
    this.unpack_encoding = session.unpack_encoding
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
  end

  function on_connect_failed(self::Session, reason::Reason)
  end

  function on_response(self::Session, msgid::Int, error::Error, result::Result)
  end

  function on_timeout(self::Session, msgid::Int)
  end

  function step_timeout(self::Session)
  end

end

function NoSyncIDGenerator
end

end # session
