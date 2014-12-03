class WeatherObservation < ActiveRecord::Base
  belongs_to :weather_station

  attr_accessible :wind_speed, :wind_direction
end
