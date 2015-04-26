#!/usr/bin/env julia

include("../src/MsgPackRpcClient.jl")
include("dataset.jl")
using MsgPackRpcClient
using Base.Test

i = 1
hostname = "localhost"
port = 5000

function test_data(data, number = 1)
  results = {}
  expects = {}
  for d in data
    future = MsgPackRpcClient.call(session, d["method"], d["arg"]; sync = false)
    push!(results, get(future) )
    if haskey(d, "expect")
      push!(expects, d["expect"])
    else
      push!(expects, d["arg"])
    end
  end

  for d in data
    println("$(number): $d ")
    try
      @test first(results[number]) == expects[number]
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

