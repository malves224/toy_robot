class RedisApplication
  def initialize
    @redis = self.class.redis_instance
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
    redis_instance.hgetall(key).transform_keys(&:to_sym)
  end

  def self.all
    hash_data = {}

    redis_instance.scan_each do |key|
      if redis_instance.type(key) == 'hash'
        hash_data[key] = redis_instance.hgetall(key)
      end
    end

    hash_data
  end

  private

  def self.redis_instance
    @redis ||= Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1')
  end
end
