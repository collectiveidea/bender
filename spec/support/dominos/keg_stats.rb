module Dom
  class KegStats < Domino
    selector "#stats"

    attribute :poured, ".poured" do |text|
      text.to_i
    end

    attribute :remaining do |text|
      text.to_i
    end
    attribute :pours do |text|
      text.to_i
    end

    attribute :average_pour_volume, ".average-pour-volume" do |text|
      text.to_f
    end

    attribute :projected_empty_date, ".projected-empty-date" do |text|
      Date.parse(text)
    end
  end
end
