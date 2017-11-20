require 'rails_helper'

describe '.execute' do
  let(:query) { 'test123' }

  %w{questions answers comments users}.each do |type|
    it "send query to #{type.capitalize} class" do
      expect(type.capitalize.singularize.constantize).to receive(:search).with(query)
      Search.new(query, type).execute
    end
  end

  it 'send query to ThinkingSphinx class' do
    expect(ThinkingSphinx).to receive(:search).with(query)
    Search.new(query).execute
  end

  it 'send qurery to ThinkingSphinx if class invalid' do
    expect(ThinkingSphinx).to receive(:search).with(query)
    Search.new(query, 'invalid_resource').execute
  end
end
