module Downloaders
  class Base
    def self.valid?(type); raise NotImplementedError; end
  end
end