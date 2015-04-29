#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'msgpack/rpc'
require 'test/unit'

$i = 1
HOSTNAME = "localhost"
PORT = 5000
TIMEOUT = 5

class SyncCall < Test::Unit::TestCase

  def get_session
    session = MessagePack::RPC::Client.new(HOSTNAME, PORT)
    session.timeout = TIMEOUT
    session
  end

  def dataset
    nothing = nil
    [
      {"method" => "echo", "arg1" => 1, "arg2" => 2, "arg3" => 3, "arg4" => 4, "expect" => [1,2,3,4]}
    ]
  end

  def test_arguments
    session = get_session
    dataset.each do |d|
      p d
      result = session.call(d["method"], d["arg1"], d["arg2"], d["arg3"], d["arg4"])
      p result
      assert_equal(result[0], d["expect"][0])
      assert_equal(result[1], d["expect"][1])
      assert_equal(result[2], d["expect"][2])
      assert_equal(result[3], d["expect"][3])
    end
    session.close()
  end
end

