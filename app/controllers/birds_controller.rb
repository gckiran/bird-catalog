class BirdsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /birds
  def index
    birds_catalogue_service = BirdsCatalogueService.new()
    birds = birds_catalogue_service.get_all_visible_birds
    render :status => 200, :json => birds.collect(&:id).collect(&:to_s).uniq
  end

  # GET /birds/1
  def show
    birds_catalogue_service = BirdsCatalogueService.new()
    bird = birds_catalogue_service.get_bird_by_id(params[:id])
    if bird.present?
      return_code = 200
      response = {:id => bird.id.to_s,
                  :name => bird.name,
                  :family => bird.family,
                  :continents => bird.continents,
                  :added => bird.added,
                  :visible => bird.visible}
    else
      return_code = 404
      response = {}
    end

    render :status => return_code, :json => response
  end

  # POST /birds
  def create
    @bird = Bird.new(bird_params)

    if @bird.save
      render :status => 201, :json => {:id => @bird.id.to_s}
    else
      render :status => 400, :json => @bird.errors
    end
  end

  # DELETE /birds/1
  def destroy
    birds_catalogue_service = BirdsCatalogueService.new()
    if birds_catalogue_service.delete_by_id(params[:id])
      return_code = 200
    else
      return_code = 404
    end
    render :status => return_code, :json => {}
  end

  private
    def bird_params
      params.permit(:name, :family, :visible, :continents => [])
    end
end
