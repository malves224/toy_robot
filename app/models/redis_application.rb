class RedisApplication
  def create(attrs)
    Redis.current.hmset(attrs.id, *attrs.to_hash.flatten)
  end

  def remove(key)
    Redis.current.del(key)
  end

  def get(key)
    Redis.current.hgetall(key).transform_keys(&:to_sym)
  end

  def update(id, attrs)
    Redis.current.hmset(id, *attrs.to_hash.flatten)
  end
end
