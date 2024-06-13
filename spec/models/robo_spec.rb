require 'rails_helper'

RSpec.describe Robo, type: :model do
  describe '#turn' do
    context "when it's north" do
      let(:robo) { Robo.new(x: 1, y: 1, f: 'NORTH') }

      it 'turns left to face West' do
        robo.turn('LEFT')
        expect(robo.f).to eq('WEST')
      end

      it 'turns left to face East' do
        robo.turn('RIGHT')
        expect(robo.f).to eq('EAST')
      end
    end
    context "when it's east" do
      let(:robo) { Robo.new(x: 1, y: 1, f: 'EAST') }

      it 'turns left to face West' do
        robo.turn('LEFT')
        expect(robo.f).to eq('NORTH')
      end

      it 'turns left to face East' do
        robo.turn('RIGHT')
        expect(robo.f).to eq('SOUTH')
      end
    end

    context "when it's south" do
      let(:robo) { Robo.new(x: 1, y: 1, f: 'SOUTH') }

      it 'turns left to face West' do
        robo.turn('LEFT')
        expect(robo.f).to eq('EAST')
      end

      it 'turns left to face East' do
        robo.turn('RIGHT')
        expect(robo.f).to eq('WEST')
      end
    end

    context "when it's west" do
      let(:robo) { Robo.new(x: 1, y: 1, f: 'WEST') }

      it 'turns left to face West' do
        robo.turn('LEFT')
        expect(robo.f).to eq('SOUTH')
      end

      it 'turns left to face East' do
        robo.turn('RIGHT')
        expect(robo.f).to eq('NORTH')
      end
    end
  end
end
