class Search
  RESOURCES = %w(all questions answers comments users).freeze

  def initialize(query, resource = 'all')
    @query = query
    @resource = if RESOURCES.include?(resource)
                  resource
                else
                  'all'
                end
  end

  def execute
    if @resource == 'all'
      ThinkingSphinx.search(escape(@query))
    else
      @resource.classify.constantize.search(escape(@query))
    end
  end

  private

  def escape(query)
    ThinkingSphinx::Query.escape(query)
  end
end
