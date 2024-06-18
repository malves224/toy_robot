class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_channel'
    @board = Board.new(size: 5)
    @commander = CommandProcessorService.new(@board)

    @connection_id = params[:id]
    @robo = nil
  end

  def unsubscribed
    return unless @robo

    @board.remove(@robo.id)
  end

  def receive(data)
    message = data['message']        
    output = @commander.call(@connection_id, message.strip, @robo).data
    ActionCable.server.broadcast('game_channel', output: output)

    @robo = Robo.get(@connection_id) if @robo.nil?
  end
end
