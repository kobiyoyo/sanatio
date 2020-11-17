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
    @search.first_name = @search.first_name.gsub(/[^0-9a-z ]/i, '') 
    @search.last_name = @search.last_name.gsub(/[^0-9a-z ]/i, '') 
    @search.url =  @search.url.gsub(/[^0-9a-z .]/i, '') 
    @fill_field = @search.first_name.blank?  && @search.last_name.blank? 
    if (@fill_field) 
        flash[:danger] = "Kindly fill in all fields"
        redirect_to searches_path

    else

      @result = Search.valid_email(@search.first_name, @search.last_name, @search.url)

      if @result != 'No Record Found'
        flash[:notice] = Search.valid_email(@search.first_name, @search.last_name, @search.url)
        redirect_to searches_path
      else
        flash.now[:danger] = 'No Record Found'
        render :new
      end
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
