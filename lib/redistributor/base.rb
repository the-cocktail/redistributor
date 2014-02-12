require 'redis'
require 'redis-namespace'


module Redistributor
  class Base

    include Redistributor::RedisExtensions

    attr_accessor :namespace

    def initialize namespace = nil
      self.namespace = namespace
      @redis_master = nil
      @redis_slave = nil
      return self
    end

    # Performance optimization: to avoid unnecessary method_missing calls,
    # we proactively define methods that dispatch to the underlying redis
    # calls.
    (Redis.public_instance_methods - Object.public_instance_methods).each do |method|
      define_method(method) do |*args, &block|
        dispatch(method, *args, &block)
      end
    end

    def respond_to_missing? method, include_private
      redis_method?(method) || super
    end

    def inspect
      "#<Redistributor::Base ( master: #{Redistributor.master}, slave: #{Redistributor.slave})>"
    end

    # This method expose the redis client directly on the block. Use it at you own peril
    def multi(redis_kind = :master)
      client = get_client(redis_kind)
      if block_given?
        client.multi do
          yield(client)
        end
      end
    end

    # This method expose the redis client directly on the block. Use it at you own peril
    def pipelined(redis_kind = :master)
      client = get_client(redis_kind)
      if block_given?
        client.pipelined do
          yield(client)
        end
      end
    end


    private

    def dispatch(method, *args, &block)
      client_for(method).send(method, *args, &block)
    end

    def redis_method?(method)
      Redis.public_instance_methods(false).include?(method)
    end

    def client_for method
      client_kind = Redistributor::Constants::REDIS_READ_OPS.include?(method.to_s)? :slave : :master
      get_client(client_kind)
    end

    def get_client redis_kind
      redis_kind_variable = "@redis_#{redis_kind}"
      if instance_variable_get(redis_kind_variable).nil?
        redis = Redis.new( {logger: Redistributor.logger}.merge(Redistributor.send(redis_kind)) )
        instance_variable_set( redis_kind_variable , Redis::Namespace.new(namespace, redis: redis) )
      end
      Redistributor.logger.debug "Redis >> #{redis_kind}"
      instance_variable_get(redis_kind_variable)
    end

  end

end