require 'spec_helper'
require 'redis'
require 'mock_redis'

describe Redistributor::RedisExtensions do

  let(:dummy_class){class Dummy; include Redistributor::RedisExtensions; end}
  let(:instance){ dummy_class.new }
  let(:redis){MockRedis.new}

  describe "#zadd_with_score" do

    before(:each) do
      instance.should_receive(:client_for).with(:master).and_return(redis)
    end

    it "should keep order between items" do
      instance.zadd_with_score "set", "c", "a"
      expect(redis.zrange("set", 0, -1)).to eq ["a", "c"]
    end


  end

end