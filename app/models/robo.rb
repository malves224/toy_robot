class Robo < RedisApplication
  DIRECTIONS = %w[NORTH EAST SOUTH WEST]
  attr_accessor :id, :x, :y, :f

  def initialize(id:, x:, y:, f:)
    @id = id
    @x = x
    @y = y
    @f = f
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

  def to_hash
    {
      id: @id,
      x: @x,
      y: @y,
      f: @f
    }
  end
end
