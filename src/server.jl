module server

#import "../include/MsgPack.jl/src/MsgPack.jl"

const PORT = 5000
const SLEEP = 3

function run()

  server = listen(PORT)
  println("DEBUG: Start msgpack-rpc-julia with port %d\n", PORT)
  @async begin
    try
      while true
        sock = accept(server)
        @async while isopen(sock)
          println("DEBUG: accept\n")
          sleep(SLEEP)
        end
      end
    catch err
      print("err")
    end
  end
  println("DEBUG: End msgpack-rpc-julia with port %d\n", PORT)

end

end #module