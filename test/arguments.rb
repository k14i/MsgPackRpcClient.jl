#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'msgpack/rpc'
require 'test/unit'
require './dataset'
require './const'

class SyncCall < Test::Unit::TestCase

  def get_session
    session = MessagePack::RPC::Client.new(HOSTNAME, PORT)
    session.timeout = TIMEOUT
    session
  end

  def test_arguments
    dataset = DataSet.new.dataset_for_arguments
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

