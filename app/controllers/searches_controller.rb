class SearchesController < ApplicationController
  before_action :set_search, only: %i[show edit update destroy]

  # GET /searches
  # GET /searches.json
  def index
    @search = Search.new
    @searches = Search.all
  end

  # GET /searches/new
  def new
    @search = Search.new
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)

    Search.valid_email(@search.first_name, @search.last_name, @search.url)

      if @search.save

       redirect_to searches_path notice: Search.valid_email(@search.first_name, @search.last_name, @search.url)

      else
        flash.now[:danger] = Search.valid_email(@search.first_name, @search.last_name, @search.url)
        render :new 
      end
    
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
      redirect_to searches_url, notice: 'Search was successfully destroyed.' 

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_search
    @search = Search.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def search_params
    params.require(:search).permit(:first_name, :last_name, :url)
  end
end
