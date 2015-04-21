module MsgPackRpcClientSocks

include("const.jl")

type Socks
  pool :: Array
end

function new()
  Socks(Union(Base.TcpSocket, Base.UdpSocket)[])
end

function show(self::Socks)
  println(self.pool)
  nothing
end

function is_empty(self::Socks)
  if length(self.pool) != 0
    return false
  else
    return true
  end
end

#function reject!(self::Socks)
#end

function get_sock(self, ptr::Int)
  self.pool[ptr]
end

function push!(self::Socks, sock::Union(Base.TcpSocket, Base.UdpSocket))
  enqueue!(self, sock)
end

function pop!(self; or_create = true, host::String = "localhost", port::Int = DEFAULT_PORT_NUMBER)
  try
    sock = pop!(self.pool)
    return sock
  catch
    # TODO: Add error handling
  end

  if or_create == true
    try
      return connect(host, port)
    catch
      # TODO: Add error handling
    end
  end

  nothing
end

function enqueue!(self::Socks, sock::Union(Base.TcpSocket, Base.UdpSocket))
  try
    Base.push!(self.pool, sock)
  catch
    self = Socks({})
  end
  self
end

function dequeue!(self::Socks)
  try
    sock = self.pool[1]
    deleteat!(self.pool, 1)
    return sock
  catch
    return nothing
  end
end

function connect_and_push!(self, host::String = "localhost", port::Int = DEFAULT_PORT_NUMBER)
  Base.push!(self.pool, connect(host, port))
  self
end

function connect_in_port_range_and_push!(self::Socks,
                                         host::String = "localhost",
                                         range::UnitRange = DEFAULT_PORT_NUMBER:DEFAULT_PORT_NUMBER)
  @sync begin
    @async for port = range
      connect_and_push!(self, host, port)
    end
  end
  self
end

function delete(self::Socks, sock::Base.TcpSocket)
  i = 1
  for x in self.pool
    if x == sock
      if isopen(self.pool[i])
        close(self.pool[i])
      end
      deleteat!(self.pool, i)
      break
    end
    i += 1
  end
  self
end

function destroy(self::Socks)
  try
    if is_empty(self)
      return true
    end
    for x in self.pool
      if x == nothing
        continue
      end
      if isopen(x)
        close(x)
      end
    end
  catch
    return false
  end
  true
end

end # module MsgPackRpcClientSocks
