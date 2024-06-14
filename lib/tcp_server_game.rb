# lib/tcp_server.rb

require 'socket'
require File.expand_path('../config/environment', __dir__)

class TcpServerGame
  def initialize(port)
    @server = TCPServer.new(port)
    @board = Board.new(size: 5)
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

    while (message = client.gets)
      puts client.peeraddr.inspect
      puts "#{message}"
      response = process_message(generate_connection_id(client), message.strip, robo)
      client.puts response

      robo = Robo.get(generate_connection_id(client)) if response.is_a?(Hash) && robo.nil?
    end

    @board.remove(robo.id) if robo
    client.close
    puts 'Client disconnected.'
  end

  private

  def process_message(connection_id, message, robo)
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
    robo ? robo.to_hash : 'Failed to place robot on the board.'
  end

  def execute_action(message, robo)
    action = message.downcase.to_sym
    if @board.respond_to?(action)
      @board.send(action, robo)
      robo.to_hash
    else
      'Unknown command.'
    end
  end

  def generate_connection_id(client)
    "#{client.peeraddr[2]}:#{client.peeraddr[1]}"
  end
end
