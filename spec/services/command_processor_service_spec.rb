require 'rails_helper'

RSpec.describe CommandProcessorService do
  let(:board) { double('Board') }
  let(:service) { described_class.new(board) }
  let(:connection_id) { '12345' }
  let(:robo) { double('Robo', to_json: '{"id":"12345","x":1,"y":1,"f":"NORTH"}') }

  describe '#call' do
    it 'processes a PLACE command' do
      allow(board).to receive(:place).and_return(robo)
      result = service.call(connection_id, 'PLACE 1,2,NORTH', nil)

      expect(result.data).to eq('{"id":"12345","x":1,"y":1,"f":"NORTH"}')
    end

    it 'returns an error if robot is not on the table' do
      result = service.call(connection_id, 'MOVE', nil)

      expect(result.data).to eq('Robot is not on the table. Use the PLACE command.')
    end

    it 'executes a valid action command' do
      allow(board).to receive(:move).and_return(robo)
      result = service.call(connection_id, 'MOVE', robo)

      expect(result.data).to eq('{"id":"12345","x":1,"y":1,"f":"NORTH"}')
    end

    it 'returns an error for an unknown command' do
      result = service.call(connection_id, 'UNKNOWN_COMMAND', robo)

      expect(result.data).to eq('Unknown command.')
    end
  end
end
