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

  def data
    nothing = nil
    [
      {"method" => "echo", "arg" => nothing},
      {"method" => "echo", "arg" => true},
      {"method" => "echo", "arg" => false},
      {"method" => "echo", "arg" => 1<<31},
      {"method" => "echo", "arg" => ""},
      {"method" => "echo", "arg" => "String"},
      {"method" => "echo", "arg" => []},
      {"method" => "echo", "arg" => {}},
      {"method" => "echo", "arg" => [10, 20, 30]},
      {"method" => "echo", "arg" => [10, "20", 30]},
     #{"method" => "echo", "arg" => {10, 20, 30}},
     #{"method" => "echo", "arg" => {{10, 20, 30}, {40, 50}, {60}} },
      {"method" => "echo", "arg" => {"key" => "value"}},
      {"method" => "echo", "arg" => {"k1" => "v1", "k2" => "v2"}},
      {"method" => "echo", "arg" => {"k1"=>nothing, "k2"=>false, "k3"=>"", "k4"=>{}, "k5"=>{"k5.1"=>false, "k5.2"=>{"k5.2.1"=>1<<31} } } },
     #{"method" => "echo", "arg" => π },
     #{"method" => "echo", "arg" => (), "expect" => {} },
     #{"method" => "echo", "arg" => ((10,20,30,),(40,50,),(60,),), "expect" => {{10,20,30},{40,50},{60}} },
    ]
  end

  def test_sync_call
    session = get_session
    data.each do |d|
      result = session.call(d["method"], d["arg"])
      p result
      assert_equal(d["arg"], result.first)
    end
    session.close()
  end
end

