#!/usr/bin/env julia

include("../src/MsgPackRpcClient.jl")
include("dataset.jl")
include("const.jl")
using MsgPackRpcClient
using Base.Test

function test_data(data, number = 1)
  for d in data
    println("$(number): $d ")
    try
      result = MsgPackRpcClient.call(session, d["method"], d["arg"]; sync = true)
      #println("d[\"arg\"] = ", d["arg"], ", result = $result", ", first(result]) = ", first(result))
      if haskey(d, "expect")
        @test first(result) == d["expect"]
      else
        @test first(result) == d["arg"]
      end
      println("  => OK")
    catch
      println("Error on d[\"arg\"] = ", d["arg"])
    end
    number += 1
  end
end

session = MsgPackRpcClientSession.create()

test_data(get_dataset())

session.destroy()

