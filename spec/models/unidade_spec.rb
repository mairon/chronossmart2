require 'rails_helper'

RSpec.describe Unidade, type: :model do
  describe 'validates relationships' do
    it 'validates relationship between Unidade and Whatsapp' do
      result = described_class.reflect_on_association(:whatsapps)

      expect(result.macro).to eq(:has_many)
    end
  end
end
