require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.create(:user)
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
        @user.uname = 1234
        expect(@user).to_not be_valid
    end
  end
end