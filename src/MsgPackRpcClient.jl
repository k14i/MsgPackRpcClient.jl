module MsgPackRpcClient

include("const.jl")
include("base.jl")
include("socks.jl")
include("session.jl")
include("future.jl")

using MsgPack

export MsgPackRpcClientSession, call, get

function call(s::MsgPackRpcClientSession.Session, method::String, params...; sync = DEFAULT_SYNC_POLICY, sock = nothing)
  if sock == nothing
    try
      sock = s.get_sock()
    catch
      MsgPackRpcClientSocks.connect_and_push!(s.socks)
      s.ptr = 1
      sock = s.get_sock()
    end
  end

  msg_id = s.next_id
  # NOTE: For compatibility, msgid must be Int32
  s.next_id >= 1<<(BIT_OF_MSGID - 1) ? s.next_id = 0 : s.next_id += 1

  future = send_request(sock, msg_id, method, params)

  if sync == true
    receive_response(sock, future)
    return get(future)
  else
    future.task = @async receive_response(sock, future)
    return future
  end
end

function send_request(sock, msg_id::Int, method::String, args)
  params = MsgPackRpcClientBase.to_a(args)
  packed_data = MsgPack.pack({REQUEST, msg_id, method, params})
  if typeof(sock) == Base.TcpSocket
    send_data_in_tcp(sock, packed_data)
  #else if typeof(sock) == Base.UdpSocket
  #  send_data_in_udp(sock, packed_data, host, port)
  #else
  #  # error
  end
  MsgPackRpcClientFuture.Future(TIMEOUT_IN_SEC, nothing, nothing, nothing, false, nothing, nothing, nothing, msg_id, nothing)
end

function send_data_in_tcp(sock::Base.TcpSocket, data)
  write(sock, data)
  nothing
end

function send_data_in_udp(sock::Base.UdpSocket, data, host::String, port::Int)
  send(sock, host, port, data)
  nothing
end

function get(future::MsgPackRpcClientFuture.Future)
  if future.task != nothing
    wait(future.task)
  end
  if future.error == nothing
    # if future.result_handler != nothing
    #   return result_handler.call()
    # end
    return future.result
  end
  if future.result == nothing
    # TODO: raise instead of return
    return nothing
  end
  # if future.error_handler != nothing
  #   return error_handler.call()
  # end
  # TODO: raise instead of return
  nothing
end

function receive_response(sock, future::MsgPackRpcClientFuture.Future; interval = DEFAULT_INTERVAL)
  unpacked_data = {}
  timeout = future.timeout

  while 0 <= timeout
    receive_data(sock, future)
    # if future.is_set == false
    #  println("continue")
    #  sleep(1)
    #  continue
    # end
    unpacked_data = MsgPack.unpack(future.raw)
    if unpacked_data[1] != RESPONSE || unpacked_data[2] != future.msg_id # type, msgid
      timeout -= interval
      sleep(interval)
      continue
    else
      break
    end
    return nothing
  end

  if unpacked_data[3] != nothing # error
    future.error = unpacked_data[3]
  end

  if unpacked_data[4] != nothing #result
    future.result = unpacked_data[4]
  end

  future
end

function receive_data(sock, future::MsgPackRpcClientFuture.Future)
  join(sock, future)
  nothing
end

function join(sock, future::MsgPackRpcClientFuture.Future; interval = DEFAULT_INTERVAL)
  timeout = future.timeout
  while future.is_set == false && timeout > 0
    future.raw = readavailable(sock)
    if length(future.raw) > 0
      future.is_set = true
      break
    end
    sleep(interval)
    timeout -= interval
  end
  future
end

end # module MsgPackRpcClient
