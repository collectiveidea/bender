module Dom
  class LeaderBoardConsumer < Domino
    selector "#leaderboard tbody tr"

    attribute :name
    attribute :total do |text|
      text.to_f
    end

    attribute :average do |text|
      text.to_f
    end

    attribute :max do |text|
      text.to_f
    end

    attribute :pours do |text|
      text.to_i
    end
  end
end
