# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141202030242) do

  create_table "SpatialIndex", :id => false, :force => true do |t|
    t.text   "f_table_name"
    t.text   "f_geometry_column"
    t.binary "search_frame"
  end

  create_table "geometry_columns_field_infos", :primary_key => "f_table_name", :force => true do |t|
    t.text    "f_geometry_column", :null => false
    t.integer "ordinal",           :null => false
    t.text    "column_name",       :null => false
    t.integer "null_values",       :null => false
    t.integer "integer_values",    :null => false
    t.integer "double_values",     :null => false
    t.integer "text_values",       :null => false
    t.integer "blob_values",       :null => false
    t.integer "max_size"
    t.integer "integer_min"
    t.integer "integer_max"
    t.float   "double_min"
    t.float   "double_max"
  end

  add_index "geometry_columns_field_infos", ["f_table_name", "f_geometry_column", "ordinal", "column_name"], :name => "sqlite_autoindex_geometry_columns_field_infos_1", :unique => true

  create_table "geometry_columns_statistics", :primary_key => "f_table_name", :force => true do |t|
    t.text      "f_geometry_column", :null => false
    t.timestamp "last_verified"
    t.integer   "row_count"
    t.float     "extent_min_x"
    t.float     "extent_min_y"
    t.float     "extent_max_x"
    t.float     "extent_max_y"
  end

  add_index "geometry_columns_statistics", ["f_table_name", "f_geometry_column"], :name => "sqlite_autoindex_geometry_columns_statistics_1", :unique => true

  create_table "geometry_columns_time", :primary_key => "f_table_name", :force => true do |t|
    t.text      "f_geometry_column",                                    :null => false
    t.timestamp "last_insert",       :default => '0000-01-01 00:00:00', :null => false
    t.timestamp "last_update",       :default => '0000-01-01 00:00:00', :null => false
    t.timestamp "last_delete",       :default => '0000-01-01 00:00:00', :null => false
  end

  add_index "geometry_columns_time", ["f_table_name", "f_geometry_column"], :name => "sqlite_autoindex_geometry_columns_time_1", :unique => true

  create_table "spatialite_history", :primary_key => "event_id", :force => true do |t|
    t.text "table_name",      :null => false
    t.text "geometry_column"
    t.text "event",           :null => false
    t.text "timestamp",       :null => false
    t.text "ver_sqlite",      :null => false
    t.text "ver_splite",      :null => false
  end

  create_table "sql_statements_log", :force => true do |t|
    t.timestamp "time_start",    :default => '0000-01-01 00:00:00', :null => false
    t.timestamp "time_end",      :default => '0000-01-01 00:00:00', :null => false
    t.text      "user_agent",                                       :null => false
    t.text      "sql_statement",                                    :null => false
    t.integer   "success",       :default => 0,                     :null => false
    t.text      "error_cause",   :default => "'ABORTED'",           :null => false
  end

  create_table "views_geometry_columns_auth", :primary_key => "view_name", :force => true do |t|
    t.text    "view_geometry", :null => false
    t.integer "hidden",        :null => false
  end

  add_index "views_geometry_columns_auth", ["view_name", "view_geometry"], :name => "sqlite_autoindex_views_geometry_columns_auth_1", :unique => true

  create_table "views_geometry_columns_field_infos", :primary_key => "view_name", :force => true do |t|
    t.text    "view_geometry",  :null => false
    t.integer "ordinal",        :null => false
    t.text    "column_name",    :null => false
    t.integer "null_values",    :null => false
    t.integer "integer_values", :null => false
    t.integer "double_values",  :null => false
    t.integer "text_values",    :null => false
    t.integer "blob_values",    :null => false
    t.integer "max_size"
    t.integer "integer_min"
    t.integer "integer_max"
    t.float   "double_min"
    t.float   "double_max"
  end

  add_index "views_geometry_columns_field_infos", ["view_name", "view_geometry", "ordinal", "column_name"], :name => "sqlite_autoindex_views_geometry_columns_field_infos_1", :unique => true

  create_table "views_geometry_columns_statistics", :primary_key => "view_name", :force => true do |t|
    t.text      "view_geometry", :null => false
    t.timestamp "last_verified"
    t.integer   "row_count"
    t.float     "extent_min_x"
    t.float     "extent_min_y"
    t.float     "extent_max_x"
    t.float     "extent_max_y"
  end

  add_index "views_geometry_columns_statistics", ["view_name", "view_geometry"], :name => "sqlite_autoindex_views_geometry_columns_statistics_1", :unique => true

  create_table "virts_geometry_columns_auth", :primary_key => "virt_name", :force => true do |t|
    t.text    "virt_geometry", :null => false
    t.integer "hidden",        :null => false
  end

  add_index "virts_geometry_columns_auth", ["virt_name", "virt_geometry"], :name => "sqlite_autoindex_virts_geometry_columns_auth_1", :unique => true

  create_table "virts_geometry_columns_field_infos", :primary_key => "virt_name", :force => true do |t|
    t.text    "virt_geometry",  :null => false
    t.integer "ordinal",        :null => false
    t.text    "column_name",    :null => false
    t.integer "null_values",    :null => false
    t.integer "integer_values", :null => false
    t.integer "double_values",  :null => false
    t.integer "text_values",    :null => false
    t.integer "blob_values",    :null => false
    t.integer "max_size"
    t.integer "integer_min"
    t.integer "integer_max"
    t.float   "double_min"
    t.float   "double_max"
  end

  add_index "virts_geometry_columns_field_infos", ["virt_name", "virt_geometry", "ordinal", "column_name"], :name => "sqlite_autoindex_virts_geometry_columns_field_infos_1", :unique => true

  create_table "virts_geometry_columns_statistics", :primary_key => "virt_name", :force => true do |t|
    t.text      "virt_geometry", :null => false
    t.timestamp "last_verified"
    t.integer   "row_count"
    t.float     "extent_min_x"
    t.float     "extent_min_y"
    t.float     "extent_max_x"
    t.float     "extent_max_y"
  end

  add_index "virts_geometry_columns_statistics", ["virt_name", "virt_geometry"], :name => "sqlite_autoindex_virts_geometry_columns_statistics_1", :unique => true

  create_table "weather_observations", :force => true do |t|
    t.integer "weather_station_id", :null => false
    t.date    "observation_date",   :null => false
    t.integer "observation_hour",   :null => false
    t.float   "wind_speed"
    t.integer "wind_direction"
  end

  add_index "weather_observations", ["weather_station_id", "observation_date", "observation_hour"], :name => "index_weather_observations_on_station_id_and_observation_time", :unique => true

  create_table "weather_stations", :id => false, :force => true do |t|
    t.integer "id",                                             :null => false
    t.string  "name",                                           :null => false
    t.string  "province",                                       :null => false
    t.spatial "latlon",   :limit => {:srid=>0, :type=>"point"}, :null => false
  end

  add_index "weather_stations", ["id"], :name => "index_weather_stations_on_id", :unique => true
  add_index "weather_stations", ["latlon"], :name => "idx_weather_stations_latlon", :spatial => true

end
