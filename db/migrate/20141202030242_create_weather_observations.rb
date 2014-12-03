class CreateWeatherObservations < ActiveRecord::Migration
  def change
    create_table :weather_observations do |t|
      t.belongs_to :weather_station
      t.datetime   :observed_at

      t.float      :wind_speed
      t.integer    :wind_direction
    end

    change_table :weather_observations do |t|
      t.index      [:weather_station_id, :observed_at], unique: true
    end
  end
end
