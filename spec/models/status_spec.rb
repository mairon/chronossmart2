require 'rails_helper'

RSpec.describe Status, type: :model do
  describe 'validates statuses' do
    it 'validates Whatsapp statuses' do
      result = described_class::WHATSAPP

      expected_result = { free: 0, occupied: 1 }

      expect(result).to eq(expected_result)
    end
  end
end
