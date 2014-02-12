module Redistributor
  module RedisExtensions

    extend ActiveSupport::Concern

    included do
    end

    def zadd_with_score key, *args
      args_with_score = args.map{|value| [float_hash(value.to_s), value.to_s ] }.flatten
      client_for(:master).zadd key, args_with_score
    end

    private

    def float_hash string
      (Digest::MD5.hexdigest(string).to_i(16)).to_f
    end

  end
end