require 'rails_helper'

RSpec.describe Robo, type: :model do
  let(:redis) { Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379') }
  let(:robo) { Robo.new(id: 'robo1', x: 1, y: 1, f: 'NORTH') }

  before(:each) do
    redis.flushdb # Limpa o banco de dados Redis antes de cada teste
  end

  describe '#report' do
    it 'does return position and direction' do
      expect(robo.report).to eq('1, 1, NORTH')
    end
  end

  describe 'a specification' do
    it 'does return hash' do
      expect(robo.to_hash).to eq({ id: robo.id, x: robo.x, y: robo.y, f: robo.f })
    end
  end

  describe '#x=' do
    it 'updates the x value and saves to Redis' do
      robo.x = 2
      expect(redis.hget('robo1', 'x')).to eq('2')
    end
  end

  describe '#y=' do
    it 'updates the y value and saves to Redis' do
      robo.y = 3
      expect(redis.hget('robo1', 'y')).to eq('3')
    end
  end

  describe '#f=' do
    it 'updates the direction and saves to Redis' do
      robo.f = 'EAST'
      expect(redis.hget('robo1', 'f')).to eq('EAST')
    end
  end

  describe '.get' do
    before do
      robo.save
    end
    it 'does return a robo' do
      response = described_class.get(robo.id)
      expect(response.id).to eq(robo.id)
    end
  end
end
