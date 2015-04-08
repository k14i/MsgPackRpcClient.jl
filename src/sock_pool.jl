module MsgPackRpcClientSockPool

export SockPool

type SockPool
  pool :: Array
end

function new()
  self = SockPool(Union(Base.TcpSocket, Nothing)[])
  self
end

function show(self::SockPool)
  println(self.pool)
  nothing
end

function is_empty(self::SockPool)
  if length(self.pool) != 0
    return false
  else
    return true
  end
end

function reject!(self::SockPool)
end

function push(self::SockPool, sock::Base.TcpSocket)
  push!(self.pool, sock)
  self
end

function add_port(self::SockPool, port::Int)
  sock = connect(port)
  push!(self.pool, sock)
  self
end

function add_port_range(self::SockPool, range::UnitRange)
  for x = range
    sock = connect(x)
    push!(self.pool, sock)
  end
  self
end

function delete(self::SockPool, sock::Base.TcpSocket)
  i = 1
  for x in self.pool
    if x == sock
      close(self[i])
      self[i] = nothing
    end
    i += 1
  end
  self
end

function destroy(self::SockPool)
  if is_empty(self)
    return nothing
  end
  for x in self.pool
    if x == nothing
      continue
    end
    close(x)
  end
  nothing
end

end # module MsgPackRpcClientSockPool

