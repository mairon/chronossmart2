require 'rails_helper'

RSpec.describe Whatsapp, type: :model do
  describe 'validates presences' do
    it 'no validates when no pass instance' do
      whatsapp = FactoryBot.build(:whatsapp, :free, instance: nil)

      whatsapp.valid?

      expect(whatsapp.errors[:instance]).to include("can't be blank")
    end

    it 'no validates when no pass token' do
      whatsapp = FactoryBot.build(:whatsapp, :free, token: nil)

      whatsapp.valid?

      expect(whatsapp.errors[:token]).to include("can't be blank")
    end

    it 'no validates when no pass status' do
      whatsapp = FactoryBot.build(:whatsapp, :free, status: nil)

      whatsapp.valid?

      expect(whatsapp.errors[:status]).to include("can't be blank")
    end
  end

  describe 'validates relationships' do
    xit 'validates relationship between Whatsapp and Unidade' do
      result = described_class.reflect_on_association(:unidade)

      expect(result.macro).to eq(:belongs_to)
    end
  end

  describe 'validates uniqueness' do
    it 'no validates when instance already exists' do
      whatsapp = FactoryBot.create(:whatsapp, :free)
      whatsapp2 = FactoryBot.build(:whatsapp, :free, instance: whatsapp.instance)

      whatsapp2.valid?

      expect(whatsapp2.errors[:instance]).to include('has already been taken')
    end
  end
end
