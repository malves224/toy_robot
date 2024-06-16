class CommandProcessorService
  def initialize(board)
    @board = board
  end

  def call(connection_id, message, robo)
    Struct.new(:data).new(process(connection_id, message, robo))
  end

  private

  def process(connection_id, message, robo)
    return place_robot(connection_id, message) if message.start_with?('PLACE')

    return 'Robot is not on the table. Use the PLACE command.' if robo.nil?

    execute_action(message, robo)
  end

  def place_robot(connection_id, message)
    params = message.split(' ')[1..]
    x = params[0].to_i
    y = params[1].to_i
    f = params[2]
    robo = @board.place(connection_id, x, y, f)
    robo ? robo.to_json : 'Failed to place robot on the board.'
  end

  def execute_action(message, robo)
    action = message.downcase.to_sym
    if @board.respond_to?(action)
      @board.send(action, robo)
      robo.to_json
    else
      'Unknown command.'
    end
  end
end
