# frozen_string_literal: true

module Influxer
  module ActiveModel3
    # Replacement of ActiveModel::Model for ActiveModel 3
    module Model
      def initialize(attributes = {})
        if attributes
          attributes.each do |attr, value|
            public_send("#{attr}=", value)
          end
        end

        super()
      end
    end
  end
end
