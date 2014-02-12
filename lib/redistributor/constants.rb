module Redistributor

  module Constants

    # Redis read operations that are automatically dispatched to slaves. Any
    # operation not listed here will be dispatched to the master.
    REDIS_READ_OPS = %w(bitcount dbsize debug dump echo exists get getbit getrange hexists hget hgetall hkeys hlen
      hmget hvals info keys lastsave lindex llen mget object ping pttl randomkey scard sismember
      smembers srandmember strlen sunion time ttl type zcard zcount zrange zrangebyscore zrank
      zrevrank zrevrangebyscore zscore lrange mapped_hmget mapped_mget sdiff sinter zrevrange
      zscore).freeze

    DEFAULT_CONNECTION = {host: 'localhost', port: 6379}

  end

end