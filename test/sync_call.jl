using MsgPackRpcClient
using Base.Test

i = 1
hostname = "localhost"
port = 5000

session = MsgPackRpcClientSession.create()

result = MsgPackRpcClient.call(session, "test")
#println(result)
expect = "Test from $(port)"
#println(expect)
@test result == expect

session.destroy()


# results = {}
# 
# for i in 1:10000
#   result = MsgPackRpcClient.call(session, "test")
#   push!(results, result)
# end
# 
# i = 1
# hostname = "localhost"
# port = 5000
# for result in results
#   @test result == "Test #$(i) from $(hostname):$(port)"
#   i += 1
# end
# 
# session.destroy()
