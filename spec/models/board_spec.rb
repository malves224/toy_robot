require 'rails_helper'
require 'redis'

RSpec.describe Board, type: :model do
  let(:board) { described_class.new(size: 5) }
  let(:redis) { Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1') }
  let(:robot) { Robot.new(id: 'robo1', x: 1, y: 1, f: 'NORTH') }

  before(:each) do
    redis.flushdb
  end

  describe '#place' do
    it 'adds a robot to the board' do
      board.place('2', '1', '1', 'NORTH')
      expect(redis.hgetall('2')).to eq('id' => '2', 'x' => '1', 'y' => '1', 'f' => 'NORTH')
    end
  end

  describe '#move' do
    it 'moves the robot within the board' do
      result = board.move(robot)
      expect(result[:x]).to eq(1)
      expect(result[:y]).to eq(2)
      expect(result[:f]).to eq('NORTH')
    end

    context "when it exceeds board size" do
      before do
        robot.x = 5
        robot.y = 5
      end

      it 'does not move the robot out of the board' do
        result = board.move(robot)
        expect(result[:x]).to eq(5)
        expect(result[:y]).to eq(5)
        expect(result[:f]).to eq('NORTH')
      end
    end
  end

  describe '#left' do
    it 'turns the robot to the left' do
      result = board.left(robot)
      expect(result[:f]).to eq('WEST')
    end
  end

  describe '#right' do
    it 'turns the robot to the right' do
      result = board.right(robot)
      expect(result[:f]).to eq('EAST')
    end
  end

  describe '#report' do
    it 'reports the current state of the robot' do
      result = board.report(robot)
      expect(result).to eq(robot.to_json)
    end
  end
end
