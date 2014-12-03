class CreateWeatherObservations < ActiveRecord::Migration
  def change
    create_table :weather_observations do |t|
      t.belongs_to :weather_station,  null: false

      t.date       :observation_date, null: false
      t.integer    :observation_hour, null: false

      t.float      :wind_speed
      t.integer    :wind_direction
    end

    change_table :weather_observations do |t|
      t.index      [:weather_station_id, :observation_date, :observation_hour], unique: true, name: 'index_weather_observations_on_station_id_and_observation_time'
    end
  end
end
