require 'rails_helper'

RSpec.describe Condomino, type: :model do
  before do
    @user = FactoryBot.create(:email)
    @condominio = FactoryBot.create(:condominio)
    @condomino = FactoryBot.create(:condomino)
  end

  describe 'creation' do
    it 'can be created if valid' do
      expect(@condomino).to be_valid
    end
    it 'will not be created if not valid user_id' do
      @condomino.update(user_id: 243)
      @condomino.save
      expect(@condomino).to_not be_valid
    end
    it 'can create the connected drive folder' do
      expect(@condomino.gdrive_user_items).to exist
    end
  end

  describe 'update' do
    it 'can be updated (admin status)' do
      @condomino.update(is_condo_admin: true)
      @condomino.save
      expect(@condomino.reload.is_condo_admin).to match(true)
    end
  end
end
