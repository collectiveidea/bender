require "rails_helper"

describe User do
  describe "#decrement_credits" do
    it "decrements the credits by the volume" do
      user = FactoryGirl.create(:user, credits: 5)
      user.decrement_credits(3)

      expect(user.credits).to eq(2)
    end

    it "does not set the value if credits are nil" do
      # If there are no credits set, the user has unlimited pours
      user = FactoryGirl.create(:user, credits: nil)
      user.decrement_credits(3)

      expect(user.credits).to eq(nil)
    end

    it "does not decrement below zero" do
      user = FactoryGirl.create(:user, credits: 5)
      user.decrement_credits(6)

      expect(user.credits).to eq(0)
    end
  end

  describe "#pours_remaining?" do
    it "is true if credits are nil" do
      # If there are no credits set, the user has unlimited pours
      user = FactoryGirl.create(:user, credits: nil)
      expect(user.pours_remaining?).to eq(true)
    end

    it "is true if credits are non zero" do
      user = FactoryGirl.create(:user, credits: 5)
      expect(user.pours_remaining?).to eq(true)
    end

    it "is false if credits are at zero" do
      user = FactoryGirl.create(:user, credits: 0)
      expect(user.pours_remaining?).to eq(false)
    end
  end

  describe "#stats" do
    let(:user) { FactoryGirl.create(:user, credits: 55.67) }
    subject { user.stats }

    it "has values model attributes" do
      is_expected.to have_key("created_at")
      is_expected.to include(
        "name" => user.name,
        "email" => user.email,
        "id" => user.id,
        "credits" => 55.67
      )
    end

    it "has values from model methods" do
      is_expected.to include(
        "gravatar" => user.gravatar_base_url,
        "first_pour_at" => user.first_pour_at,
        "last_pour_at" => user.last_pour_at,
        "recent_pour_count" => user.recent_pour_count,
        "pour_count_by_volume" => user.pour_count_by_volume,
        "recent_pours" => user.recent_pours,
      )
    end
  end
end
