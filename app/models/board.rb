class Board < RedisApplication
  attr_accessor :robots, :size, :directions

  def initialize(size:, directions: %w[NORTH EAST SOUTH WEST])
    super()
    @size = size
    @directions = directions
  end

  def move(robo)
    movements = {
      'NORTH' => [0, 1], 'EAST' => [1, 0], 'SOUTH' => [0, -1], 'WEST' => [-1, 0]
    }

    x, y = movements[robo.f]

    robo.x += x if (x + robo.x).between?(1, @size)
    robo.y += y if (y + robo.y).between?(1, @size)
    robo.to_hash
  end

  def left(robo)
    turn_robot(robo, 'LEFT')
  end

  def right(robo)
    turn_robot(robo, 'RIGHT')
  end

  def report(robo)
    robo.to_json
  end

  def place(id, x, y, f)
    robo = Robo.new(id: id, x: x, y: y, f: f)
    add_robo(robo)
    robo
  end

  private

  def add_robo(robo)
    raise ArgumentError, 'element must be instances of Robo' unless robo.is_a?(Robo)

    create(robo)
  end

  def turn_robot(robo, direction)
    current_index = @directions.index(robo.f)
    new_index = if direction == 'LEFT'
                  current_index - 1
                elsif direction == 'RIGHT'
                  current_index + 1
                end

    robo&.f = @directions[new_index % @directions.size]
    robo.to_hash
  end
end
