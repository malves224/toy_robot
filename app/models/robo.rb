class Robo
  DIRECTIONS = %w[NORTH EAST SOUTH WEST]
  attr_accessor :x, :y, :f

  def initialize(x:, y:, f:)
    @x = x
    @y = y
    @f = f
  end

  def report
    "#{@x}, #{@y}, #{@f}"
  end

  def turn(direction)
    current_index = DIRECTIONS.index(@f)
    new_index = if direction == 'LEFT'
                  current_index - 1
                elsif direction == 'RIGHT'
                  current_index + 1
                end

    @f = DIRECTIONS[new_index % DIRECTIONS.size]
  end
end
