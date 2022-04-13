require "rails_helper"

describe Achievement do
  before :all do
    Keg.delete_all
    User.delete_all
    Pour.delete_all

    FactoryBot.create(:keg, id: 1, name: "Keg1")
    FactoryBot.create(:keg, id: 2, name: "Keg2")

    FactoryBot.create(:user, id: 0, name: "Guest")
    FactoryBot.create(:user, id: 1, name: "Foo")
    FactoryBot.create(:user, id: 2, name: "Bar")
  end

  before :each do
    allow(FayeNotifier).to receive(:send_message).and_return(true)
    Pour.delete_all
  end

  describe "calculates metrics with appropriate options" do
    before do
      FactoryBot.create(:pour, user_id: 0, keg_id: 1, volume: 0)
      FactoryBot.create(:pour, user_id: 1, keg_id: 1, volume: 12)
      FactoryBot.create(:pour, user_id: 2, keg_id: 1, volume: 23, created_at: 31.days.ago, finished_at: 31.days.ago)
      FactoryBot.create(:pour, user_id: 1, keg_id: 1, volume: 999, created_at: 5.seconds.ago, finished_at: nil)
      FactoryBot.create(:pour, user_id: 0, keg_id: 2, volume: 999)
      FactoryBot.create(:pour, user_id: 1, keg_id: 2, volume: 34)
      FactoryBot.create(:pour, user_id: 2, keg_id: 2, volume: 45, created_at: 31.days.ago, finished_at: 31.days.ago)
    end

    it "ignores pours for Guests" do
      expect(Achievement.calculate({metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true, # needed to reverse results to get max value since first result is always used
                                     keg_id: 2}).value.to_d).to eq(BigDecimal("45"))
    end

    it "ignores pours that haven't finished" do
      expect(Achievement.calculate({metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                     keg_id: 1}).value.to_d).to eq(BigDecimal("23"))
    end

    it "calculates metrics for all pours" do
      expect(Achievement.calculate({metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true}).value.to_d).to eq(BigDecimal("68"))
    end

    it "limits calculation by a keg" do
      expect(Achievement.calculate({metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                     keg_id: 1}).value.to_d).to eq(BigDecimal("23"))
    end

    it "limits calculation by a time period" do
      expect(Achievement.calculate({metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                    time_gt: Time.now - 30.days}).value.to_d).to eq(BigDecimal("46"))
    end

    it "limits calculation by multiple options" do
      expect(Achievement.calculate({metric: "sum(volume)",
                                       name: "Foo",
                                description: "Bar",
                                    reverse: true,
                                     keg_id: 1,
                                    time_gt: Time.now - 30.days}).value.to_d).to eq(BigDecimal("12"))
    end
  end

  describe "calculates total ounces poured" do
    before do
      FactoryBot.create(:pour, user_id: 1, volume: 12)
      FactoryBot.create(:pour, user_id: 1, volume: 34)
      FactoryBot.create(:pour, user_id: 2, volume: 23)
      FactoryBot.create(:pour, user_id: 2, volume: 45)
    end

    it "calculates maximum volume by user" do
      expect(Achievement.total_poured_max.value.to_d).to eq(BigDecimal("68"))
    end

    it "identifies user for maximum volume" do
      expect(Achievement.total_poured_max.user_name).to eq("Bar")
    end

    it "calculates minimum volume by user" do
      expect(Achievement.total_poured_min.value.to_d).to eq(BigDecimal("46"))
    end

    it "identifies user for minimum volume" do
      expect(Achievement.total_poured_min.user_name).to eq("Foo")
    end
  end

  describe "calculates single pour volume" do
    before do
      FactoryBot.create(:pour, user_id: 1, volume: 12)
      FactoryBot.create(:pour, user_id: 1, volume: 34)
      FactoryBot.create(:pour, user_id: 2, volume: 23)
      FactoryBot.create(:pour, user_id: 2, volume: 45)
    end

    it "calculates maximum pour by user" do
      expect(Achievement.single_pour_max.value.to_d).to eq(BigDecimal("45"))
    end

    it "identifies user for maximum pour" do
      expect(Achievement.single_pour_max.user_name).to eq("Bar")
    end

    it "calculates minimum pour by user" do
      expect(Achievement.single_pour_min.value.to_d).to eq(BigDecimal("12"))
    end

    it "identifies user for minimum pour" do
      expect(Achievement.single_pour_min.user_name).to eq("Foo")
    end
  end

  describe "calculates number of pours" do
    before do
      FactoryBot.create_list(:pour, 3, {user_id: 1})
      FactoryBot.create_list(:pour, 2, {user_id: 2})
    end

    it "calculates maximum pour count by user" do
      expect(Achievement.total_pours_max.value.to_i).to eq(3)
    end

    it "identifies user for maximum pour count" do
      expect(Achievement.total_pours_max.user_name).to eq("Foo")
    end

    it "calculates minimum pour count by user" do
      expect(Achievement.total_pours_min.value.to_i).to eq(2)
    end

    it "identifies user for minimum pour count" do
      expect(Achievement.total_pours_min.user_name).to eq("Bar")
    end
  end

  describe "calculates pour duration" do
    before do
      FactoryBot.create(:pour, user_id: 1, started_at: 10.seconds.ago, finished_at: Time.current)
      FactoryBot.create(:pour, user_id: 2, started_at: 10.minutes.ago, finished_at: Time.current)
    end

    it "calculates maximum pour duration by user" do
      expect(Achievement.pour_time_max.value.to_f).to be_within(1.second).of(10.minutes)
    end

    it "identifies user for maximum pour duration" do
      expect(Achievement.pour_time_max.user_name).to eq("Bar")
    end

    it "calculates minimum pour duration by user" do
      expect(Achievement.pour_time_min.value.to_f).to be_within(1.second).of(10.seconds)
    end

    it "identifies user for minimum pour duration" do
      expect(Achievement.pour_time_min.user_name).to eq("Foo")
    end
  end
end
