module Downloaders
  class Base
    def self.available?; raise NotImplementedError; end
  end
end