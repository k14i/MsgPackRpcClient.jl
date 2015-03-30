module IOLoop

export IOLoop

type IOLoop

  function IOLoop()
  end

  function instance()
  end

  function initialized()
  end

  function install(self::IOLoop)
  end

  function clear_instance()
  end

  function current(instance=true)
  end

  function make_current(self::IOLoop)
  end

  function clear_current()
  end

  function configurable_base(cls)
  end

  function configurable_default(cls)
  end

  function initialize(self::IOLoop, make_current=nothing)
  end

  functionclose(self::IOLoop, all_fds=false)
  end

  function add_handler(self::IOLoop, fd, handler, events)
  end

  function update_handler(self::IOLoop, fd, events)
  end

  function remove_handler(self::IOLoop, fd)
  end



end

end # module IOLoop
