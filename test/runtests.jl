#!/usr/bin/env julia

#include("../src/MsgPackRpcClient.jl")
#using MsgPackRpcClient

tests = ["sync_call", "async_call"]

println("Running tests:")

#@sync begin

addprocs(1)
@spawn remotecall(2, run(`ruby test_server.rb`))

for t in tests
  test_fn = "$t.jl"
  println(" * $test_fn")
  run(`julia $test_fn`)
end

try
  run(`pkill ruby`)
catch
end

#end
