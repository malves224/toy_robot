class Board < RedisApplication
  attr_accessor :robots, :size, :directions

  def initialize(size:, directions: %w[NORTH EAST SOUTH WEST])
    super()
    @size = size
    @directions = directions
  end

  def move(robot)
    movements = {
      'NORTH' => [0, 1], 'EAST' => [1, 0], 'SOUTH' => [0, -1], 'WEST' => [-1, 0]
    }

    x, y = movements[robot.f]

    robot.x += x if (x + robot.x).between?(1, @size)
    robot.y += y if (y + robot.y).between?(1, @size)
    robot.to_hash
  end

  def left(robot)
    turn_robot(robot, 'LEFT')
  end

  def right(robot)
    turn_robot(robot, 'RIGHT')
  end

  def report(robot)
    robot.to_json
  end

  def place(id, x, y, f)
    robot = Robot.new(id: id, x: x, y: y, f: f)
    add_robo(robot)
    robot
  end

  private

  def add_robo(robot)
    raise ArgumentError, 'element must be instances of Robot' unless robot.is_a?(Robot)

    create(robot)
  end

  def turn_robot(robot, direction)
    current_index = @directions.index(robot.f)
    new_index = if direction == 'LEFT'
                  current_index - 1
                elsif direction == 'RIGHT'
                  current_index + 1
                end

    robot&.f = @directions[new_index % @directions.size]
    robot.to_hash
  end
end
