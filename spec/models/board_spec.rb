require 'rails_helper'
require 'redis'

RSpec.describe Board, type: :model do
  let(:board) { described_class.new(size: 5) }
  let(:redis) { Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379') }
  let(:robo) { Robo.new(id: 'robo1', x: 1, y: 1, f: 'NORTH') }

  before(:each) do
    redis.flushdb # Limpa o banco de dados Redis antes de cada teste
  end

  describe '#add_robo' do
    it 'adds a robot to the board' do
      board.add_robo(robo)
      expect(redis.hgetall('robo1')).to eq('id' => 'robo1', 'x' => '1', 'y' => '1', 'f' => 'NORTH')
    end

    it 'raises an error if the element is not a Robo instance' do
      expect { board.add_robo(OpenStruct.new) }.to raise_error(ArgumentError, 'element must be instances of Robo')
    end
  end

  describe '#remove_robo' do
    it 'removes a robot from the board' do
      redis.hmset('robo1', 'x', '1', 'y', '1', 'f', 'NORTH')
      board.remove_robo('robo1')
      expect(redis.exists('robo1')).to be(0)
    end
  end

  describe '#turn_robot' do
    context "when it's north" do
      before do
        board.add_robo(robo)
      end

      it 'turns left to face West' do
        board.turn_robot(robo, 'LEFT')

        expect(robo.f).to eq('WEST')
      end

      it 'turns left to face East' do
        board.turn_robot(robo, 'RIGHT')

        expect(robo.f).to eq('EAST')
      end
    end
    context "when it's east" do
      let(:robo_east) { Robo.new(id: '2', x: 1, y: 1, f: 'EAST') }

      it 'turns left to face West' do
        board.turn_robot(robo_east, 'LEFT')

        expect(robo_east.f).to eq('NORTH')
      end

      it 'turns left to face East' do
        board.turn_robot(robo_east, 'RIGHT')

        expect(robo_east.f).to eq('SOUTH')
      end
    end

    context "when it's south" do
      let(:robo_south) { Robo.new(id: '3', x: 1, y: 1, f: 'SOUTH') }

      it 'turns left to face West' do
        board.turn_robot(robo_south, 'LEFT')

        expect(robo_south.f).to eq('EAST')
      end

      it 'turns left to face East' do
        board.turn_robot(robo_south, 'RIGHT')

        expect(robo_south.f).to eq('WEST')
      end
    end

    context "when it's west" do
      let(:robo_west) { Robo.new(id: '3', x: 1, y: 1, f: 'WEST') }

      it 'turns left to face West' do
        board.turn_robot(robo_west, 'LEFT')

        expect(robo_west.f).to eq('SOUTH')
      end

      it 'turns left to face East' do
        board.turn_robot(robo_west, 'RIGHT')

        expect(robo_west.f).to eq('NORTH')
      end
    end
  end
end
