require 'rails_helper.rb'
require 'user.rb'

RSpec.describe User,type: :model do
  before do
    @user = FactoryBot.create(:email)
    @user1 = FactoryBot.create(:email1)
  end

  describe "creation" do
    it "can be created if valid" do
      expect(@user).to be_valid
    end

    it "will not be created if not valid username" do
      @user.uname = nil
      expect(@user).to_not be_valid
    end

    it "will not be created if not valid email" do
        @user.email = "InvalidMail"
        expect(@user).to_not be_valid
    end

    it "will not be created if not valid password" do
        @user.password = 1234
        expect(@user).to_not be_valid
    end

    it "will not be created if mail exist" do
      @user.email = 'test1@example.com'
      expect(@user).to_not be_valid
    end
  end

  describe "update" do
    it "will not be update if not valid password" do
      @user.save!
      @user.update(password: "Test")
      expect(@user).to_not be_valid
    end

    it "will not be update if not valid email address" do
      @user.save!
      @user.update(email: "InvalidAdress")
      expect(@user).to_not be_valid
    end

    it "will not be update if email address exist" do
      @user.save!
      @user.update(email: "test1@example.com")

      expect(@user).to_not be_valid
    end
  end

  describe "destroy" do
    it "will be destroy" do
      @user.destroy
      expect { @user.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it "will be canceled all shareholdings in condominiums" do
      @condominio = FactoryBot.create(:condominio)
      @partecipazione = FactoryBot.create(:condomino,user_id: @user.id,condominio_id: @condominio.id)
      @user.destroy
      expect { @user.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { @partecipazione.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end