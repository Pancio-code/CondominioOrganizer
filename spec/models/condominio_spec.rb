require 'rails_helper.rb'
require 'condominio.rb'

RSpec.describe Condomino do
  before do
    @condominio = FactoryBot.create(:condominio)

  end

  describe "creation" do
    it "can be created if valid" do
      expect(@condominio).to be_valid
    end
  end

  describe "update" do
    it "will be updated if valid" do
      @condominio.save!
      @condominio.update(nome:"Condominio di Paolo")
      expect(@condominio).to be_valid
    end
  end

  describe "destruction" do
    it "will be destroyed" do
      @condominio.destroy
      expect{@condominio.reload}.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
