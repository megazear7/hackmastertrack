class SpecializationsController < ApplicationController
  def retrieve
    character = Character.find(params[:character_id])
    item = Item.find(params[:item_id])
    stat_name = params[:stat_name]
    @specialization = Specialization.find_by(character_id: character.id, item_id: item.id, stat_name: stat_name)
    spec = {}
    spec["value"] = @specialization.nil? ? 0 : @specialization.value
    spec["cost"] = character.specialization_cost(item, stat_name)
    render json: spec
  end

  def create
    @character = Character.find(params[:specialization][:character_id])
    @item = Item.find(params[:specialization][:item_id])
    stat_name = params[:specialization][:stat_name]
    if params[:specialization][:value].to_i < 5
      if @character.proficiencies.pluck(:id).include? @item.proficiency.id
        if @character.specialization_available(@item, stat_name)
          cost = @character.specialization_cost(@item, stat_name)
          if @character.building_points > cost
            @character.building_points -= cost
            @specialization = Specialization.find_or_create_by(character_id: params[:specialization][:character_id],
                                                               item_id: params[:specialization][:item_id],
                                                               stat_name: stat_name)
            @specialization.update(specialization_params)

            @character.save
            respond_to do |format|
              if @specialization.save
                format.html { redirect_to request.referer, notice: 'Specialization was successfully created.' }
                format.json { render action: 'show', status: :created, location: @specialization }
              else
                format.html { redirect_to request.referer, notice: 'Specialization was successfully created.' }
                format.json { render json: @specialization.errors, status: :unprocessable_entity }
              end
            end
          else
            respond_to do |format|
              format.html { redirect_to request.referer, notice: 'You did not have enough building points for that' }
              format.json { render json: @specialization.errors, status: :unprocessable_entity }
            end
          end
        else
          respond_to do |format|
            format.html { redirect_to request.referer, notice: 'You must specialize in the other attributes before you can specialize in ' + stat_name}
            format.json { render json: @specialization.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to request.referer, notice: 'You need to have the proficiency first' }
          format.json { render json: @specialization.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, notice: 'You cannot specialize more than 5.' }
        format.json { render json: @specialization.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def specialization_params
      params.require(:specialization).permit(
        :character_id,
        :item_id,
        :value,
        :stat_name
      )
    end
 
end
