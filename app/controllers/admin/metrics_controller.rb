class Admin::MetricsController < ApplicationController
  respond_to :json

  def achievements
    pours = Pour.select('name, sum(volume) as sum_volume, count(pours.id) as count, avg(volume) as average, max(volume) as max_volume, min(volume) as min_volume').group('users.name').order('sum_volume desc').joins(:user)
 
    @achievements = []

    achievement = { name: "The Lush", description: "Most Total oz Poured" }
    achievement[:user_name] = pours.first.name
    achievement[:value] = pours.first.sum_volume
    achievement[:value_type] = :decimal
    @achievements << achievement

    achievement = { name: "Designated Driver", description: "Least Total oz Poured" }
    achievement[:user_name] = pours.last.name
    achievement[:value] = pours.last.sum_volume
    achievement[:value_type] = :decimal
    @achievements << achievement

    pours.sort_by! { |pour| pour.max_volume }

    achievement = { name: "Big Gulp", description: "Largest Single Pour" }
    achievement[:user_name] = pours.last.name
    achievement[:value] = pours.last.max_volume
    achievement[:value_type] = :decimal
    @achievements << achievement

    pours.sort_by! { |pour| pour.min_volume }

    achievement = { name: "Little Dipper", description: "Smallest Single Pour" }
    achievement[:user_name] = pours.first.name
    achievement[:value] = pours.first.min_volume
    achievement[:value_type] = :decimal
    @achievements << achievement

    pours.sort_by! { |pour| pour.count }

    achievement = { name: "!!! Most Pours", description: "Most Total Pours" }
    achievement[:user_name] = pours.last.name
    achievement[:value] = pours.last.count
    achievement[:value_type] = :integer
    @achievements << achievement

    achievement = { name: "!!! Least Pours", description: "Least Total Pours" }
    achievement[:user_name] = pours.first.name
    achievement[:value] = pours.first.count
    achievement[:value_type] = :integer
    @achievements << achievement

    pours = Pour.where('finished_at IS NOT NULL').select('name, max(finished_at - started_at) as max_pour_time, min(finished_at - started_at) as min_pour_time').group('users.name').order('max_pour_time desc').joins(:user)

    achievement = { name: "Long Winded", description: "Longest Single Pour" }
    achievement[:user_name] = pours.first.name
    achievement[:value] = pours.first.max_pour_time
    achievement[:value_type] = :time
    @achievements << achievement

    pours.sort_by! { |pour| pour.min_pour_time }

    achievement = { name: "Quick Draw", description: "Shortest Single Pour" }
    achievement[:user_name] = pours.first.name
    achievement[:value] = pours.first.min_pour_time
    achievement[:value_type] = :time
    @achievements << achievement

    respond_with @achievements
  end
end
