class RedisApplication
  def initialize
    @redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379')
  end

  def create(attrs)
    @redis.hmset(attrs.id, *attrs.to_hash.flatten)
  end

  def remove(key)
    @redis.del(key)
  end

  def update(id, attrs)
    @redis.hmset(id, *attrs.to_hash.flatten)
  end

  def self.get(key)
    redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379')
    redis.hgetall(key).transform_keys(&:to_sym)
  end
end
