require 'socket'

class TcpServerGame
  def initialize(port)
    @server = TCPServer.new(port)
    @board = Board.new(size: 5)
    @commander = CommandProcessorService.new(@board)
    puts "Server is running on port #{port}..."
  end

  def run
    loop do
      client = @server.accept
      handle_client(client)
    end
  end

  def handle_client(client)
    puts "Client connected: #{client.peeraddr.inspect}"
    client.puts 'Hello! You are connected to the server.'
    robo = nil
    id = "#{client.peeraddr[2]}:#{client.peeraddr[1]}"

    while (message = client.gets)
      output = @commander.call(id, message.strip, robo).data
      client.puts output

      robo = Robo.get(id) if robo.nil?
    end

    @board.remove(robo.id) if robo
    client.close
    puts 'Client disconnected.'
  end
end
