class SearchesController < ApplicationController
  skip_authorization_check

  def show
  end

  def create
    @resource = params[:resource]
    @query = params[:search]
    @search_results = Search.new(@query, @resource).execute
  end
end
