class SearchesController < ApplicationController
  skip_authorization_check

  def show
  end

  def create
    @resource = params[:resource]
    @query = params[:search]
    @search_results = Search.execute(@query, @resource)
  end
end
