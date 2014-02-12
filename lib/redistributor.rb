# encoding: utf-8
require "redistributor/version"
require "logger"
require "active_support"
require "active_support/dependencies"


module Redistributor

  extend ActiveSupport::Autoload

  autoload :Constants
  autoload :Base
  autoload :RedisExtensions

  mattr_accessor :master, :logger
  mattr_writer :slave

  # Defaults
  def self.set_default_config
    self.master  = Constants::DEFAULT_CONNECTION
    self.logger  = Logger.new(STDOUT)
    self.slave   = nil
  end
  self.set_default_config


  def self.slave
    @@slave || self.master
  end

  def self.config(&block)
    yield(self)
  end

end


