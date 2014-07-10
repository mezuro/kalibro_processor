module CompoundResultsCalculator
  class JavascriptEvaluator
    def add_variable(identifier, value)
      validate_identifier(identifier)
      #TODO add variable to context
    end

    private

    def validate_identifier(identifier)
      #TODO raise exception if identifier is invalid
    end
  end
end