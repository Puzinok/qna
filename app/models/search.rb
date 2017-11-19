class Search
  TYPES = %w(all questions answers comments users).freeze

  class << self
    def execute(query, type)
      if type == 'all'
        ThinkingSphinx.search(escape(query))
      else
        klass(type).search(escape(query)) if TYPES.include?(type)
      end
    end
    
    private 
    
    def klass(string)
      string.classify.constantize
    end

    def escape(query)
      ThinkingSphinx::Query.escape(query)
    end
  end
end
