module loop

export Loop

type Loop

  instance::Function
  start::Function
  stop::Function
  attach_periodic_callback::Function
  dettach_periodic_callback::Function

  function Loop()
    this = new()
    this
  end

  function instance()
  end

  function start()
  end

  function stop()
  end

  function attach_periodic_callback()
  end

  function dettach_periodic_callback()
  end

end

end # module loop