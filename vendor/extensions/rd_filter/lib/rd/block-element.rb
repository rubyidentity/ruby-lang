require 'rd/element'
require 'rd/labeled-element'

module RD
  # Block-level Element of document tree. abstruct class.
  class BlockElement < Element
  end

  class Headline < BlockElement
    include NonterminalElement
    include LabeledElement

    MARK2LEVEL = {
      "=" => 1,
      "==" => 2,
      "===" => 3,
      "====" => 4,
      "+" => 5,
      "++" => 6
    }
    
    attr_accessor :level
    attr_reader :title
    
    def initialize(level_num)
      @level = level_num
      @title = []
    end
    
    def accept(visitor)
      visitor.visit_Headline(self)
    end

    def calculate_label
      ret = ""
      @title.each do |i|
	ret << i.to_label
      end
      ret
    end
    private :calculate_label
    
    def Headline.mark_to_level(mark_str)
      MARK2LEVEL[mark_str] or
	raise ArgumentError, "#{mark_str} is irregular for Headline mark."
    end

    def children
      @title
    end
  end
  
  class Include < BlockElement
    include TerminalElement
    
    attr_accessor :filename
    
    def initialize(filename)
      @filename = filename
    end
    
    def accept(visitor)
      visitor.visit_Include(self)
    end
  end # Include
  
  class TextBlock < BlockElement
    include NonterminalElement
    
    attr_accessor :content
    
    def initialize()
      @content = []
    end
    
    def accept(visitor)
      visitor.visit_TextBlock(self)
    end
    
    def children
      @content
    end
  end
  
  class Verbatim < BlockElement
    include TerminalElement
    
    attr_reader :content
    
    def initialize(content_strings = [])
      @content = content_strings  # Array of String
    end
    
    def accept(visitor)
      visitor.visit_Verbatim(self)
    end
    
    def each_line
      @content.each do |i|
	yield(i)
      end
    end
  end
end
