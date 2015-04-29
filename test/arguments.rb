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

  def dataset_for_arguments
    nothing = nil
    [
      {"method" => "echo", "arg1" => 1, "arg2" => 2, "arg3" => 3, "arg4" => 4, "expect" => [1,2,3,4]}
    ]
  end

  def test_sync_call
    session = get_session
    dataset.each do |d|
      result = session.call(d["method"], d["arg"])
      p result
      assert_equal(d["arg"], result.first)
    end
    session.close()
  end

  def test_arguments
    session = get_session
    dataset_for_arguments.each do |d|
      p d
      result = session.call(d["method"], d["arg1"], d["arg2"], d["arg3"], d["arg4"])
      p result
      assert_equal(d["arg1"], result[0])
      assert_equal(d["arg2"], result[1])
      assert_equal(d["arg3"], result[2])
      assert_equal(d["arg4"], result[3])
    end
    session.close()
  end
end

