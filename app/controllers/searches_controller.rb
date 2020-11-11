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
    @search.email = Search.valid_email(@search.first_name, @search.last_name, @search.url)

    respond_to do |format|
      if @search.save
        format.html { redirect_to searches_path, notice: 'Search was successfully created.' }

      else
        format.html { render :new }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
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
