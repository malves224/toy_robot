class Robot < RedisApplication
  attr_accessor :id
  attr_reader :x, :y, :f

  def initialize(id:, x:, y:, f:)
    super()
    @id = id
    @x = x.to_i
    @y = y.to_i
    self.f = f
  end

  def report
    "#{@x}, #{@y}, #{@f}"
  end

  def x=(value)
    @x = value
    update(@id, to_hash)
  end

  def y=(value)
    @y = value
    update(@id, to_hash)
  end

  def f=(value)
    @f = value
    update(@id, to_hash)
  end

  def save
    create(self)
  end

  def self.get(id)
    new(super(id))
  end

  def to_hash
    {
      id: @id,
      x: @x,
      y: @y,
      f: @f
    }
  end
end
