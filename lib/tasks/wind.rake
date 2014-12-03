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

          puts "fetching data for #{date.strftime('%Y-%m-%d')} ..."

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
  task :import do
    speeds = []

    for filename in Dir.glob(DATA_DIR.join('*.csv'))
      unless filename.match(/(\d+)-/) 
        STDERR.puts "failed to determine station ID from #{filename}"
        next
      end
      station_id = $1
 
      csv = CSV.read(filename)

      puts "data for station #{station_id}:"

      station_rows = csv[0..3]
      station_rows.each do |row|
        puts "#{row[0]}: #{row[1]}"
      end

      weather_rows = csv[17..-1]
      weather_rows.each do |row|
        time  = DateTime.strptime(row[0], '%Y-%m-%d %H:%M')
        dir   = row[12].present? ? row[12].to_i*10 : nil
        speed = row[14].present? ? row[14].to_i : nil

        speeds.push(speed) if speed

        #puts "#{time.strftime('%Y-%m-%d %H:%M')}: #{speed} km/h, #{dir} deg"
      end 

      puts
    end 

    speeds.sort!
    puts "min speed: #{speeds.first*0.539957} kts"
    puts "max speed: #{speeds.last*0.539957} kts"
    puts "avg speed: #{speeds.inject { |sum, s| sum + s }.to_f/speeds.size*0.539957} kts"
    puts "median speed: #{speeds[speeds.length/2]*0.539957} kts"
  end
end
