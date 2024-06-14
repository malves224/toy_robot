class Robo < RedisApplication
  DIRECTIONS = %w[NORTH EAST SOUTH WEST]
  attr_accessor :id, :x, :y, :f

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
    unless DIRECTIONS.include?(value)
      raise ArgumentError, "Invalid direction '#{value}'. Allowed values are: #{DIRECTIONS.join(', ')}"
    end

    @f = value
    update(@id, to_hash)
  end

  def self.get(id)
    robo = super(id)
    Robo.new(robo)
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
