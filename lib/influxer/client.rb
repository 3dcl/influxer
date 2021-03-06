# frozen_string_literal: true

require "influxdb"

module Influxer
  # InfluxDB API client
  class Client < ::InfluxDB::Client
    def initialize
      super(nil, Influxer.config.as_json.symbolize_keys!)
    end

    def time_precision
      @config.time_precision
    end
  end
end
