require 'rails_helper'

RSpec.describe Robot, type: :model do
  let(:redis) { Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1') }
  let(:robot) { Robot.new(id: 'robo1', x: 1, y: 1, f: 'NORTH') }

  before(:each) do
    redis.flushdb # Limpa o banco de dados Redis antes de cada teste
  end

  describe '#report' do
    it 'does return position and direction' do
      expect(robot.report).to eq('1, 1, NORTH')
    end
  end

  describe 'a specification' do
    it 'does return hash' do
      expect(robot.to_hash).to eq({ id: Robot.id, x: Robot.x, y: Robot.y, f: Robot.f })
    end
  end

  describe '#x=' do
    it 'updates the x value and saves to Redis' do
      robot.x = 2
      expect(redis.hget('robo1', 'x')).to eq('2')
    end
  end

  describe '#y=' do
    it 'updates the y value and saves to Redis' do
      robot.y = 3
      expect(redis.hget('robo1', 'y')).to eq('3')
    end
  end

  describe '#f=' do
    it 'updates the direction and saves to Redis' do
      robot.f = 'EAST'
      expect(redis.hget('robo1', 'f')).to eq('EAST')
    end
  end

  describe '.get' do
    before do
      robot.save
    end
    it 'does return a Robot' do
      response = described_class.get(robot.id)
      expect(response.id).to eq(robot.id)
    end
  end
end
