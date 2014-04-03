class Language
  LANGUAGES = [ :C, :CPP, :JAVA, :PYTHON ]
  attr_reader :type

  def initialize(type)
    if self.class.is_valid?(type)
      @type = type
    else
      raise TypeError.new("Language #{type} not supported")
    end
  end

  def self.is_valid?(type)
    type.nil? ? false : LANGUAGES.include?(type.to_sym)
  end
end
