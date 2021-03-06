require 'ougai/formatters/base'
require 'json'

module Ougai
  module Formatters
    class Bunyan < Base
      attr_accessor :jsonize, :with_newline

      def initialize
        super
        @jsonize = true
        @with_newline = true
      end

      def call(severity, time, progname, data)
        dump({
          name: progname || @app_name,
          hostname: @hostname,
          pid: $$,
          level: to_level(severity),
          time: time,
          v: 0
        }.merge(data))
      end

      def to_level(severity)
        case severity
        when 'INFO'
          30
        when 'WARN'
          40
        when 'ERROR'
          50
        when 'FATAL'
          60
        when 'ANY'
          70
        else # DEBUG
          20
        end
      end

      private

      def dump(data)
        return data unless @jsonize
        data[:time] = data[:time].iso8601(3)
        str = JSON.generate(data)
        str << "\n" if @with_newline
        str
      end
    end
  end
end
