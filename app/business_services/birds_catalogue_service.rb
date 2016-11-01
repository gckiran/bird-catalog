class BirdsCatalogueService
  def get_bird_by_id(id)
    if id.present?
      begin
        Bird.find(id)
      rescue Mongoid::Errors::DocumentNotFound
      end
    end
  end

  def get_all_visible_birds
    @birds = Bird.where(visible: true)
  end

  def delete_by_id(id)
    @bird = get_bird_by_id(id)
    if @bird.present?
      @bird.destroy
      return true
    else
      return false
    end
  end

end