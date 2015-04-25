#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'msgpack/rpc'
#require 'msgpack'
require 'socket'

class TestServer
  attr_accessor :time, :hostname, :port

  def initialize(port)
    @time = 0
    @hostname = Socket.gethostname
    @port = port
  end

  def echo(*msg)
    p msg
    return msg
  rescue e
    p "Error: "
    p e
  end

  def test
    @time = @time + 1
    #ret = "Test ##{@time} from #{@hostname}:#{@port}"
    #ret = "Test from #{@hostname}:#{@port}"
    ret = "Test from #{@port}"
    puts ret
    return ret
  end
end

if ARGV[0]
  port = ARGV[0]
else
  port = 5000
end

puts "Starting test server on port #{port}"

svr = MessagePack::RPC::Server.new
svr.listen("0.0.0.0", port, TestServer.new(port))

Signal.trap(:TERM) { svr.stop }
Signal.trap(:INT) { svr.stop }

svr.run
