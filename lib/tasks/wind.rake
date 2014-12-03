require 'csv'
require 'date'
require 'fileutils'
require 'rest-client'

namespace :wind do
  STATION_IDS = %w(27226 96 6831 6813 152 27382 145 153 29733 137)
  YEAR_RANGE  = 1994..2014
  MONTH_RANGE = 6..6

  DATA_DIR = Rails.root.join('data')

  desc "Scrape hourly wind data from #{YEAR_RANGE.first}-#{YEAR_RANGE.last}"
  task :scrape do
    BULK_URL    = %q(http://climate.weather.gc.ca/climateData/bulkdata_e.html)
    for station_id in STATION_IDS
      puts "fetching data for station #{station_id} ..."

      for year in YEAR_RANGE
        for month in MONTH_RANGE
          date = Date.new(year, month)

          puts "fetching data from #{date.strftime('%Y-%m-%d')} ..."

          response = RestClient.get BULK_URL, :params => {
                                                :format    => :csv,
                                                :stationID => station_id,
                                                :Year      => date.year,
                                                :Month     => date.month,
                                                :timeframe => 1
                                              }

          if response.code == 200
            filename = "#{station_id}-#{date.strftime('%Y%m%d')}.csv"

            FileUtils.mkpath DATA_DIR

            File.open(DATA_DIR.join(filename), 'w') do |f|
              f.write response.body.encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?')
            end
          else
            STDERR.puts "failed to fetch data for station #{station_id} for #{date.strftime('%Y-%m-%d')}"
          end
        end
      end

      puts
    end
  end

  desc "Import scraped wind data into the database"
  task :import => :environment do
    for filename in Dir.glob(DATA_DIR.join('*.csv'))
      unless filename.match(/(\d+)-(\d+)/)
        STDERR.puts "failed to determine station ID from #{filename}"
        next
      end
      station_id, observation_date = $1.to_i, Date.strptime($2, '%Y%m%d')

      csv = CSV.read(filename)

      station_name, province, latlon = nil
      station_name = csv[0][1]
      province     = csv[1][1]
      latlon       = "POINT(#{csv[2][1].to_f} #{csv[3][1].to_f})"

      WeatherStation.where(
        id: station_id
      ).first_or_create!(
        name: station_name, province: province, latlon: latlon
      )

      puts "importing data from station #{station_id} on #{observation_date.strftime('%Y-%m-%d')} ..."

      weather_rows = csv[17..-1]
      weather_rows.each do |row|
        observation_datetime = DateTime.strptime(row[0], '%Y-%m-%d %H:%M')

        wind_direction = row[12].present? ? row[12].to_i*10 : nil
        wind_speed     = row[14].present? ? row[14].to_i    : nil

        WeatherObservation.where(
          weather_station_id: station_id,
          observation_date:   observation_datetime.to_date,
          observation_hour:   observation_datetime.hour
        ).first_or_create!(
          wind_speed: wind_speed, wind_direction: wind_direction
        )
      end
    end

    puts
  end
end
