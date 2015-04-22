include("../src/MsgPackRpcClient.jl")
using MsgPackRpcClient

#tests = ["sync_call", "async_call"]
tests = ["sync_call"]

println("Running tests:")

#task = @async `ruby test_server.rb`
#`ruby test_server.rb`

for t in tests
  test_fn = "$t.jl"
  println(" * $test_fn")
  include(test_fn)
end

#wait(task)
