require 'rails_helper'

describe '.execute' do
  let(:query) { 'test123' }

  %w{questions answers comments users}.each do |type|
    it "send query to class" do
      expect(type.capitalize.singularize.constantize).to receive(:search).with(query)
      Search.execute(query, type)
    end
  end

  it 'send query to ThinkingSphinx class' do
    expect(ThinkingSphinx).to receive(:search).with(query)
    Search.execute(query, 'all')
  end
end
