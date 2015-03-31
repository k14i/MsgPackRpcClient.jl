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

  function close(self::IOLoop, all_fds=false)
  end

  function add_handler(self::IOLoop, fd, handler, events)
  end

  function update_handler(self::IOLoop, fd, events)
  end

  function remove_handler(self::IOLoop, fd)
  end

  function set_blocking_signal_threshold(self::IOLoop, seconds, action)
  end

  function set_blocking_log_threshold(self::IOLoop, seconds)
  end

  function log_stack(self::IOLoop, signal, frame)
  end

  function start(self::IOLoop)
  end

  function _setup_logging(self::IOLoop)
  end

  function stop(self::IOLoop)
  end

  function run_sync(self::IOLoop, func, timeout=nothing)
  end

  function time(self::IOLoop)
  end

  function add_timeout(self::IOLoop, deadline, callback, args::Array, kwargs::Dict)
  end

  function call_later(self::IOLoop, delay, callback, args::Array, kwargs::Dict)
  end

  function call_at(self::IOLoop, when, callback, args::Array, kwargs::Dict)
  end

  function remove_timeout(self::IOLoop, timeout)
  end

  function add_callback(self::IOLoop, callback, args::Array, kwargs::Dict)
  end

  function add_callback_from_signal(self::IOLoop, callback, args::Array, kwargs::Dict)
  end

  function spawn_callback(self::IOLoop, callback, args::Array, kwargs::Dict)
  end

  function add_future(self::IOLoop, future, callback)
  end

  function _run_callback(self::IOLoop, callback)
  end

  function handle_callback_exception(self::IOLoop, callback)
  end

  function split_fd(self::IOLoop, fd)
  end

  function close_fd(self::IOLoop, fd)
  end

end


type PollIOLoop
end

type _Timeout
end

type PeriodicCallback
end

end # module IOLoop
