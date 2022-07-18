require 'rails_helper'

RSpec.describe Condomino, type: :model do
  before do
    @user = FactoryBot.create(:email)
    @condominio = FactoryBot.create(:condominio)
    @condomino = FactoryBot.create(:condomino,user_id: @user.id,condominio_id: @condominio.id )
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
      expect(@condomino.gdrive_user_items).to_not be_nil
    end
  end

  describe 'update' do
    it 'can be updated (admin status)' do
      @condomino.update(is_condo_admin: true)
      @condomino.save
      expect(@condomino.reload.is_condo_admin).to match(true)
    end
  end
  describe 'destruction' do
    it 'can be destroyed' do
      @condomino.destroy
      expect{@condomino.reload}.to raise_error ActiveRecord::RecordNotFound
      expect{@condomino.reload.gdrive_user_items}.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
