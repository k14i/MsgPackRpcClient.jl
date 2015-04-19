#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'msgpack/rpc'

class HelloServer
  attr_accessor :time

  def initialize
    @time = 0
  end

  def hello
    @time = @time + 1
    puts @time
    return "Hello, World!"
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
svr.listen("0.0.0.0", port, HelloServer.new)

Signal.trap(:TERM) { svr.stop }
Signal.trap(:INT) { svr.stop }

svr.run
