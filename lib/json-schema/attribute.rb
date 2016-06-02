require 'json-schema/errors/validation_error'

module JSON
  class Schema
    class Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
      end

      def self.build_fragment(fragments)
        "#/#{fragments.join('/')}"
      end

      def self.validation_error(processor, message, fragments, current_schema, failed_attribute, record_errors, details=nil)
        error = ValidationError.new(message, fragments, failed_attribute, current_schema, details)
        if record_errors
          processor.validation_error(error)
        else
          raise error
        end
      end

      def self.validation_errors(validator)
        validator.validation_errors
      end

      TYPE_CLASS_MAPPINGS = {
        "string" => String,
        "number" => Numeric,
        "integer" => Integer,
        "boolean" => [TrueClass, FalseClass],
        "object" => Hash,
        "array" => Array,
        "null" => NilClass,
        "any" => Object
      }

      def self.data_valid_for_type?(data, type)
        valid_classes = TYPE_CLASS_MAPPINGS.fetch(type) { return true }
        Array(valid_classes).any? { |c| data.is_a?(c) }
      end
    end
  end
end
