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

  def test_sync_call
    dataset = DataSet.new.dataset
    session = get_session
    dataset.each do |d|
      result = session.call(d["method"], d["arg"])
      p result
      assert_equal(d["arg"], result.first)
    end
    session.close()
  end
end

