module Catalog
  module Domain
    module ValueObjects
      class CatalogCode
        MAX_LENGTH = 64
        VALID_PATTERN = /\A[A-Z0-9_-]+\z/
        ASCII_EDGE_WHITESPACE = /\A[ \t\n\r\f\v]+|[ \t\n\r\f\v]+\z/

        attr_reader :value

        def initialize(input)
          raise ArgumentError, "Catalog Code must be a String" unless input.is_a?(String)

          canonical = input.gsub(ASCII_EDGE_WHITESPACE, "").upcase
          unless canonical.length.between?(1, MAX_LENGTH) && VALID_PATTERN.match?(canonical)
            raise ArgumentError, "Catalog Code is invalid"
          end

          @value = canonical.freeze
          freeze
        end

        def ==(other)
          other.instance_of?(self.class) && other.value == value
        end
        alias eql? ==

        def hash
          [ self.class, value ].hash
        end

        def to_s
          value
        end
      end
    end
  end
end
