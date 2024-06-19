class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_channel'
    @board = Board.new(size: 5)
    @commander = CommandProcessorService.new(@board)

    @connection_id = params[:id]
    @robot = nil
  end

  def unsubscribed
    return unless @robot

    @board.remove(@robot.id)
  end

  def receive(data)
    message = data['message']        
    output = @commander.call(@connection_id, message.strip, @robot).data
    ActionCable.server.broadcast('game_channel', output: output)

    @robot = Robot.get(@connection_id) if @robot.nil?
  end
end
