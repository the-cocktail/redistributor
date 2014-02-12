require 'spec_helper'

describe Redistributor do

  describe ".config" do

    before(:each) do
      Redistributor.set_default_config
    end

    it "should set a default connection for master" do
      expect(Redistributor.master).to eq({host: 'localhost', port: 6379})
    end

    it "should set a default connection for slave" do
      expect(Redistributor.slave).to eq({host: 'localhost', port: 6379})
    end

    it "should change master and slave if master conf is changed" do
      Redistributor.config do |config|
        config.master = {host: 'some host', port: 6379}
      end
      expect(Redistributor.master).to eq({host: 'some host', port: 6379})
      expect(Redistributor.slave).to eq({host: 'some host', port: 6379})
    end

    it "should change master and slave if both are changed" do
      Redistributor.config do |config|
        config.master = {host: 'some master host', port: 6379}
        config.slave = {host: 'some slave host', port: 6379}
      end
      expect(Redistributor.master).to eq({host: 'some master host', port: 6379})
      expect(Redistributor.slave).to eq({host: 'some slave host', port: 6379})
    end

  end

end