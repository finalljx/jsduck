require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class New < BooleanTag
    def initialize
      @key = :new
      # unicode black star char
      # A :tooltip field gets injected to this signature in Process::Versions
      @signature = {:long => "&#9733;", :short => "&#9733;"}
    end
  end
end
