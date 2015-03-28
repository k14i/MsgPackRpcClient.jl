module loop

export Loop

type Loop

  instance::Function
  start::Function
  stop::Function
  attach_periodic_callback::Function
  dettach_periodic_callback::Function

  function Loop(loop=nothing)
    this                        = new()
    this.ioloop                 = loop # or ioloop.IOLoop()
    this.ioloop.make_current()
    this.periodic_callback      = nothing
    this.periodic_callback_time = 1

    this.instance                  = function() instance(this) end
    this.start                     = function() start(this) end
    this.stop                      = function() stop(this) end
    this.attach_periodic_callback  = function() attach_periodic_callback(this, this.periodic_callback, this.periodic_callback_time) end
    this.dettach_periodic_callback = function() dettach_periodic_callback(this) end

    this
  end

  function instance(self::Loop)
    # return Loop(ioloop.IOLoop.current())
  end

  function start(self::Loop)
    self.ioloop.start()
  end

  function stop(self::Loop)
    self.ioloop.stop()
  end

  function attach_periodic_callback(self::Loop, callback::Callback, callback_time::Int)
  end

  function dettach_periodic_callback(self::Loop)
  end

end

end # module loop
