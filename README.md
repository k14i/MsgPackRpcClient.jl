# MessagePack RPC Client for Julia

A Julia implementation of MessagePack-RPC Client Library.


## Installation

In the Julia CLI:

```julia
Pkg.add("MsgPackRpcClient")
```

Or in your code:

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
  MsgPackRpcClient.call(session, "SOME_PRE-DEFINED_METHOD")
```

Or simplly:

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

---

## Specification

### Data Types

* Session
  * socks::MsgPackRpcClientSocks
    * A pool of sockets.
  * ptr::Int
    * Pointer for current socket in the pool.
  * next_id::Int
    * 32-bit sequential id for next session.
* Future
  * is_set::Bool
    * If error or result are set or not (true or false).
  * error::Any
    * Error field of MessagePack format.
  * result::Any
    * Result field of MessagePack format.
  * raw::Any
    * Received data in MessagePack binary format.
  * msg_id::Int
    * 32-bit sequential id of the session.
  * task::Union(Task, Nothing)
    * Asynchronous task to join.


### MsgPackRpcClient.jl APIs

* MsgPackRpcClient module
  * `call(session::MsgPackRpcClientSession.Session, method::String, params...; sync = true, sock = nothing)`
    * Call a `method` with `params` using the `session`. `sync` and `sock` are optional.
    * Returns `Future.result` for a sync call.
    * Returns `Future` type object for an async call.
  * `get(future::MsgPackRpcClientFuture.Future)`
    * Join and get the result of an asynchronous call.
* MsgPackRpcClientSession module
  * `create(socks::MsgPackRpcClientSocks.Socks = MsgPackRpcClientSocks.Socks({}))`
    * Create a `Session` object. `socks` is optional.
  * `create_sock(session::Session, host::String = "localhost", port::Int = DEFAULT_PORT_NUMBER)`
    * Create a socket for `host`:`port` and push it into the `session.socks`.
  * `get_sock(session::Session)`
    * Get a socket from `session.socks` pointed by `session.ptr`.
  * `rotate(session::Session)`
    * Change the current socket in the `session.socks` into the next one.
  * `destroy(session::Session)`
    * Disconnect and delete all the sockets.
    * Reset the `session.ptr` and the `session.next_id`


### Compatibility

Folloing table explains type mapping between Julia and MessagePack-RPC.

| Julia Built-in Types  | Example       | MsgPack Types | Derived from        |
| --------------------- | ------------- | ------------- | ------------------- |
| Nothing               | nothing       | Nil           | MsgPack.jl          |
| Bool                  | true          | Boolean       | MsgPack.jl          |
| Int (8,16,32,64)      | 1<<63 - 1     | Integer       | MsgPack.jl          |
| Int128                |               | --            | MsgPack, MsgPack.jl |
| Uint (8,16,32,64)     | 1<<63         | Integer       | MsgPack.jl          |
| Uint128               |               | --            | MsgPack, MsgPack.jl |
| Float16               |               | --            | MsgPack, MsgPack.jl |
| Float (32,64)         | 1.0           | Float         | MsgPack.jl          |
| String                | "foo"         | String        | MsgPack.jl          |
| Vector{Uint8}         |               | Binary        | MsgPack.jl          |
| Vector                |               | Array         | MsgPack.jl          |
| Array{Any,1}          | {1.0, 2, "3"} | Array         | MsgPack.jl          |
| Array{None,1}         | []            | Array         | MsgPack.jl          |
| Tuple                 | ((1,2,)3,)    | Array         | MsgPackRpcClient.jl |
| Dict                  | {"k" => "v"}  | Map           | MsgPack.jl          |
| (MsgPack.jl) Ext      |               | Extended      | MsgPack.jl          |


---

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

