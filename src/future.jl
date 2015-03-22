module future

export Future

type Loop end
type Error end
type Result end
type Callback end
type Handler end

type Future
  loop::Loop
  error::Error
  result::Result
  set_flag::Bool
  timeout::Int
  callback::Callback
  error_handler::Hnadler
  result_handler::Hnadler

  join::Function
  get::Function
  set::Function
  set_result::Function
  set_error::Function
  attach_callback::Function
  attach_error_handler::Function
  attach_result_handler::Function
  step_timeout::Function

  function Future(loop, timeout, callback)
    this                = new()
    this.loop           = loop
    this.error          = nothing
    this.result         = nothing
    this.set_flag       = false
    this.timeout        = timeout
    this.callback       = callback
    this.error_handler  = nothing
    this.result_handler = nothing

    this.join                  = function() join(this) end
    this.get                   = function() get(this) end
    this.set                   = function() set(this, error, result) end
    this.set_result            = function() set_result(this, result) end
    this.set_error             = function() set_error(this, error) end
    this.attach_callback       = function() attach_callback(this, callback) end
    this.attach_error_handler  = function() attach_error_handler(this, error_handler) end
    this.attach_result_handler = function() attach_result_handler(this, result_handler) end
    this.step_timeout          = function() step_timeout(this) end

    this
  end

  function join(self::Future)
  end

  function get(self::Future)
  end

  function set(self::Future, error::Error, result::Result)
  end

  function set_result(self::Future, result::Result)
  end

  function set_error(self::Future, error::Error)
  end

  function attach_callback(self::Future, callback::Callback)
  end

  function attach_error_handler(self::Future, handler::Hnadler)
  end

  function attach_result_handler(self::Future, handler::Handler)
  end

  function step_timeout(self::Future)
  end

end

end # module future
