#!/usr/bin/env julia

include("../src/MsgPackRpcClient.jl")
include("const.jl")
include("dataset.jl")
using MsgPackRpcClient
using Base.Test

function get_max_arg(data; prefix = "arg")
  i = 1
  while i < 65536
    if haskey(data, "$(prefix)$(i)")
      i += 1
    else
      break
    end
  end
  i - 1
end

function test_data(data, number = 1)
  for d in data
    println("$(number): $d ")
    #try
      max_arg = get_max_arg(d)

      if haskey(d, "arg4")
        result = MsgPackRpcClient.call(session, d["method"], d["arg1"], d["arg2"], d["arg3"], d["arg4"]; sync = true)
      elseif haskey(d, "arg3")
        result = MsgPackRpcClient.call(session, d["method"], d["arg1"], d["arg2"], d["arg3"]; sync = true)
      elseif haskey(d, "arg2")
        result = MsgPackRpcClient.call(session, d["method"], d["arg1"], d["arg2"]; sync = true)
      elseif haskey(d, "arg1")
        result = MsgPackRpcClient.call(session, d["method"], d["arg1"]; sync = true)
      else
        error
      end

      #println("result = ", result)
      #println("first(result) = ", first(result))
      if haskey(d, "expect")
        for i = 1:max_arg
          @test result[i] == d["expect"][i]
        end
      end
      println("  => OK")
    #catch
    #  #println("Error on d[\"arg\"] = ", d["arg"])
    #  println("Error")
    #end
    number += 1
  end
end

session = MsgPackRpcClientSession.create()

test_data(get_dataset_for_arguments())

session.destroy()

