require 'spec_helper'
require 'redis'
require 'mock_redis'

describe Redistributor::Base do

  describe ".new" do

    it "should retun an instance of Redistributor::Base" do
      expect(Redistributor::Base.new.class).to eq Redistributor::Base
    end

    it "should accept a namespace param" do
      expect(Redistributor::Base.new(:my_namespace).namespace).to eq :my_namespace
    end

  end

  describe "read methods should be forwarded to slave" do

    let(:redistributor){ Redistributor::Base.new }
    let(:stub_redis){ double('null object').as_null_object }

    it do
      redistributor.should_receive(:get_client).with(:slave).exactly(Redistributor::Constants::REDIS_READ_OPS.size).and_return(stub_redis)
      Redistributor::Constants::REDIS_READ_OPS.each{ |method| redistributor.send(method) }
    end

  end

  describe "#multi" do

    let(:redistributor){ Redistributor::Base.new }
    let(:redis){MockRedis.new}

    it "should be forwarded to master by default" do
      redistributor.should_receive(:get_client).with(:master).once.and_return(redis)
      redistributor.multi do |r|
        r.set 'foo', 'bar'
        r.get 'foo'
      end
    end

    it "should be forwarded to slave if specified" do
      redistributor.should_receive(:get_client).with(:slave).once.and_return(redis)
      redistributor.multi(:slave) do |r|
        r.get 'foo'
        r.get 'wadus'
      end
    end

  end


  describe "#pipelined" do

    let(:redistributor){ Redistributor::Base.new }
    let(:redis){MockRedis.new}

    it "should be forwarded to master by default" do
      redistributor.should_receive(:get_client).with(:master).once.and_return(redis)
      redistributor.pipelined do |r|
        r.set 'foo', 'bar'
        r.get 'foo'
      end
    end

    it "should be forwarded to slave if specified" do
      redistributor.should_receive(:get_client).with(:slave).once.and_return(redis)
      redistributor.pipelined(:slave) do |r|
        r.get 'foo'
        r.get 'wadus'
      end
    end

  end

end