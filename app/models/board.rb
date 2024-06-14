class Board < RedisApplication
  attr_accessor :robots, :size, :directions

  def initialize(size:, directions: %w[NORTH EAST SOUTH WEST])
    @size = size
    @directions = directions
  end

  def add_robo(robo)
    raise ArgumentError, 'element must be instances of Robo' unless robo.is_a?(Robo)

    create(robo)
  end

  def remove_robo(robo_id)
    remove(robo_id)
  end

  def turn_robot(robo, direction)
    current_index = @directions.index(robo.f)
    new_index = if direction == 'LEFT'
                  current_index - 1
                elsif direction == 'RIGHT'
                  current_index + 1
                end

    robo&.f = @directions[new_index % @directions.size]
  end
end
