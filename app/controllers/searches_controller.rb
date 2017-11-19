class SearchesController < ApplicationController
  skip_authorization_check

  def show
  end

  def create
    @search_results = ThinkingSphinx.search(params[:search])
  end
end