#!/usr/bin/env julia

include("../src/MsgPackRpcClient.jl")
include("dataset.jl")
using MsgPackRpcClient
using Base.Test

i = 1
hostname = "localhost"
port = 5000

function test_data(data, number = 1)
  for d in data
    println("$(number): $d ")
    try
      result = MsgPackRpcClient.call(session, d["method"], d["message"]; sync = true)
      #println("d[\"message\"] = ", d["message"], ", result = $result", ", first(result]) = ", first(result))
      if haskey(d, "expect")
        @test first(result) == d["expect"]
      else
        @test first(result) == d["message"]
      end
      println("  => OK")
    catch
      println("Error on d[\"message\"] = ", d["message"])
    end
    number += 1
  end
end

session = MsgPackRpcClientSession.create()

test_data(get_dataset())

session.destroy()

