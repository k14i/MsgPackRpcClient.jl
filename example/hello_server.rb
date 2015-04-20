#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# NOTE: Do once -> gem install msgpack-rpc
require 'msgpack/rpc'
require 'socket'

class HelloServer
  attr_accessor :time, :hostname, :port

  def initialize(port)
    @time = 0
    @hostname = Socket.gethostname
    @port = port
  end

  def hello
    @time = @time + 1
    puts @time
    return "Hello, World! ##{@time} from #{@hostname}:#{@port}"
  end

  def hello0
    @time = @time + 1
    puts @time
    return "Hello, World! 0"
  end

  def hello1
    @time = @time + 1
    puts @time
    return "Hello, World! 1"
  end

  def async_hello
    as = MessagePack::RPC::AsyncResult.new

    Thread.new do
      sleep 1
      as.result "ok."
    end

    return as
  end
end

if ARGV[0]
  port = ARGV[0]
else
  port = 5000
end

svr = MessagePack::RPC::Server.new
svr.listen("0.0.0.0", port, HelloServer.new(port))

Signal.trap(:TERM) { svr.stop }
Signal.trap(:INT) { svr.stop }

svr.run
