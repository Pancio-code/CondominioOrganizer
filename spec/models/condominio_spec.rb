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
    it "cant be created if nome comune longer than 25 characters" do
      @condominio.comune = 'geagaghagasghagawgawgawsghfaeofhaofdhoavauiouhawofofohaw'
      expect(@condominio).to_not be_valid
    end
    it 'cant be created if nome comune shorter than 1 character' do
      @condominio.comune = ''
      expect(@condominio).to_not be_valid
    end
    it 'cant be created if nome longer than 25 characters' do
      @condominio.nome = 'jgsgfhaihgfouBAOGJUbaUGOUBgfoabgfshgoishogihapfihapfhawpghfah'
      expect(@condominio).to_not be_valid
    end
    it 'cant be created if nome shorter than 1 character' do
      @condominio.nome = ''
      expect(@condominio).to_not be_valid
    end
    it 'cant be created if indirizzo is in the wrong format' do
      @condominio.indirizzo = 'test'
      expect(@condominio).to_not be_valid
    end
  end

  describe "update" do
    it "will be updated if valid" do
      @condominio.save!
      @condominio.update(nome:"Condominio di Paolo")
      expect(@condominio).to be_valid
    end
    it "will not be updated nome comune longer than 25 characters" do
      @condominio.save!
      @condominio.update(comune: 'geagaghagasghagawgawgawsghfaeofhaofdhoavauiouhawofofohaw')
      expect(@condominio).to_not be_valid
    end
    it "will not be updated nome comune shorter than 1 character" do
      @condominio.save!
      @condominio.update(comune: '')
      expect(@condominio).to_not be_valid
    end
    it "will not be updated nome comune longer than 25 character" do
      @condominio.save!
      @condominio.update(nome: 'jgosjpgjawgjapgjoajgawjpgagaghaoighfoaibgoagasgw')
      expect(@condominio).to_not be_valid
    end
    it "will not be updated nome shorter than 1 character" do
      @condominio.save!
      @condominio.update(nome: '')
      expect(@condominio).to_not be_valid
    end
    it 'will not be updated if indirizzo is in the wrong format' do
      @condominio.save!
      @condominio.update(indirizzo: 'test')
      expect(@condominio).to_not be_valid
    end
  end

  describe "destruction" do
    it "will be destroyed" do
      @condominio.destroy
      expect{@condominio.reload}.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
