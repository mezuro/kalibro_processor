module CompoundResultsCalculator
  class JavascriptEvaluator

    def initialize
      @script = V8::Context.new #V8 is a JavaScript interpreter
    end

    def add_variable(identifier, value)
      validate_identifier(identifier)
      @script[identifier] = value
    end

    private

    def validate_identifier(identifier)
      raise Errors::InvalidIdentifierError.new("Invalid identifier: #{identifier}") if (identifier =~ /^[a-zA-Z_$][a-zA-Z0-9_$]*$/).nil?
    end
  end
end