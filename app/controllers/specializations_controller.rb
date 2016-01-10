class SpecializationsController < ApplicationController
  def retrieve
    character = Character.find(params[:character_id])
    item = Item.find(params[:item_id])
    stat_name = params[:stat_name]
    @specialization = Specialization.find_by(character_id: character.id, item_id: item.id, stat_name: stat_name)
    value = @specialization.nil? ? 0 : @specialization.value
    render json: value
  end

  def create
    @character = Character.find(params[:specialization][:character_id])
    @item = Item.find(params[:specialization][:item_id])
    if @character.proficiencies.pluck(:id).include? @item.proficiency.id
      if @character.building_points > params[:specialization][:bp_cost].to_i
        @character.building_points -= params[:specialization][:bp_cost].to_i
        @specialization = Specialization.find_or_create_by(character_id: params[:specialization][:character_id],
                                                         item_id: params[:specialization][:item_id],
                                                         stat_name: params[:specialization][:stat_name] )
        @specialization.update(specialization_params)

        @character.save
        respond_to do |format|
          if @specialization.save
            format.html { redirect_to item_path(@specialization.item.id), notice: 'Specialization was successfully created.' }
            format.json { render action: 'show', status: :created, location: @specialization }
          else
            format.html { redirect_to item_path(@specialization.item.id), notice: 'Specialization was successfully created.' }
            format.json { render json: @specialization.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to character_path(@character), notice: 'You did not have enough building points for that' }
          format.json { render json: @specialization.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to item_path(@item), notice: 'You need to have the proficiency first' }
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
