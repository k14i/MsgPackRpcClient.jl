# MessagePack RPC Client for Julia

A Julia implementation of MessagePack-RPC Client Library.


## Installation

```julia
import MsgPackRpcClient
```

### Dependency

* MsgPack.jl


## Usage

At first, you should create a session.

```julia
  session = MsgPackRpcClientSession.create()
```

The session can hold multiple sockets.

```julia
  MsgPackRpcClientSession.create_sock(session, "localhost", 5000)
  MsgPackRpcClientSession.create_sock(session, "localhost", 5001)
  MsgPackRpcClientSession.create_sock(session, "localhost", 5002)
```

Or if you use an empty session, a socket may be created automatically when "call" is executed.

Then, you can call a server.

```julia
  call(session, "SOME_PRE-DEFINED_METHOD")
```

You can specify additional arguments; sync and sock.

You can call the server in async instead of default sync way.

```julia
  call(session, "SOME_PRE-DEFINED_METHOD"; sync = false)
```

When you use async call, the call function returns a future.
If you want to get the result, use get() function.

```julia
  future = call(session, "SOME_PRE-DEFINED_METHOD"; sync = false)
  get(future)
```

And you can specify a socket in the pool of the session.

```julia
  call(session, "SOME_PRE-DEFINED_METHOD"; sock = last(session.socks.pool))
```

After all, you must disconnect from all the servers.

```julia
  session.destroy()
```


## Example

See examples.


## Copyright and License

  The MsgPackRpcClient.jl package is licensed under the MIT Expat License:

    Copyright (c) 2015: Keisuke TAKAHASHI.
    
    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:
    
    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

