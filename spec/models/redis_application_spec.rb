# spec/redis_application_spec.rb
require 'rails_helper'
require 'redis'

RSpec.describe RedisApplication, type: :model do
  let(:redis_app) { RedisApplication.new }
  let(:key) { 'test_key' }
  let(:attrs) { double('Attrs', id: '123', to_hash: { 'a' => 1, 'b' => 2 }) }

  before do
    allow(Redis).to receive(:new).and_return(redis)
  end

  let(:redis) { instance_double(Redis) }

  describe '#create' do
    it 'sets hash values in Redis' do
      expect(redis).to receive(:hmset).with('123', 'a', 1, 'b', 2)
      redis_app.create(attrs)
    end
  end

  describe '#remove' do
    it 'deletes a key from Redis' do
      expect(redis).to receive(:del).with('test_key')
      redis_app.remove('test_key')
    end
  end

  describe '#get' do
    it 'retrieves hash values from Redis and transforms keys to symbols' do
      allow(redis).to receive(:hgetall).with('test_key').and_return('a' => '1', 'b' => '2')
      expect(redis_app.get('test_key')).to eq({ a: '1', b: '2' })
    end
  end

  describe '#update' do
    it 'updates hash values in Redis' do
      expect(redis).to receive(:hmset).with('123', 'a', 1, 'b', 2)
      redis_app.update('123', attrs)
    end
  end
end
