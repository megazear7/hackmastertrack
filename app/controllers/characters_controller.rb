class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :edit, :update, :destroy, :level_up_edit, :level_up_update, :add_xp, :add_items, :equip_items, :add_proficiency, :remove_proficiency]

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.all
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    @combat_rose = @character.calculate_combat_rose
  end

  # GET /characters/new
  def new
    @character = Character.new
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(character_params)
    @character.level = 1
    @character.exp = 0
    @character.building_points += 40
    class_cost = BpCostByRaceClass.where(
                        character_class_id: @character.character_class_id,
                        race_id: @character.race_id).first
    @character.give_class_benefits
    @character.give_race_benefits
    if class_cost.nil?
      #flash[:notice] << 'That Character Class combination is not in the system.'
      render :new
    else
      @character.building_points -= class_cost.bp_cost
      
      respond_to do |format|
        if @character.save
          format.html { redirect_to @character, notice: 'Character was successfully created.' }
          format.json { render :show, status: :created, location: @character }
        else
          format.html { render :new }
          format.json { render json: @character.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /characters/1
  # PATCH/PUT /characters/1.json
  def update
    respond_to do |format|
      if @character.update(character_params)
        format.html { redirect_to @character, notice: 'Character was successfully updated.' }
        format.json { render :show, status: :ok, location: @character }
      else
        format.html { render :edit }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.json
  def destroy
    @character.destroy
    respond_to do |format|
      format.html { redirect_to characters_url, notice: 'Character was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def level_up_edit
  end

  def level_up_update

    @character.strength     += params[:character][:strength].to_f/100
    @character.intelligence += params[:character][:intelligence].to_f/100
    @character.wisdom       += params[:character][:wisdom].to_f/100
    @character.dexterity    += params[:character][:dexterity].to_f/100
    @character.constitution += params[:character][:constitution].to_f/100
    @character.charisma     += params[:character][:charisma].to_f/100
    @character.health       += params[:character][:health].to_i

    @character.building_points += 15

    # add level up stuff here...

    @character.level += 1

    respond_to do |format|
      if @character.save
        format.html { redirect_to character_url(@character), notice: 'Successfully leveled up!.' }
        format.json { head :no_content }
      else
        format.html { redirect_to character_url(@character), notice: 'Error leveling up' }
        format.json { head :no_content }
      end
    end
  end

  def add_xp
    @character.exp += params[:character][:exp].to_i
    respond_to do |format|
      if @character.save
        format.html { redirect_to character_url(@character), notice: 'Experience successfully added.' }
        format.json { head :no_content }
      else
        format.html { redirect_to character_url(@character), notice: 'Error adding experience' }
        format.json { head :no_content }
      end
    end
  end

  def add_items
    item_to_take = Item.where(name: params[:character][:item_to_take]).first
    item_instance = ItemInstance.new
    item_instance.item = item_to_take
    if params[:commit] == "Buy Item"
      cost = item_instance.item.buy_cost
      @character.silver = 0 if @character.silver.nil?
      if @character.silver > cost
        @character.silver -= cost
        @character.save
        item_instance.character = @character
        item_instance.save
        if params[:page] == "item_index"
          redirect_to items_path(anchor: params[:page_location]), notice: 'Items Successfuly Added, total cost was: ' + cost.to_s
        else
          redirect_to character_url(@character), notice: 'Items Successfuly Purchased, total cost was: ' + cost.to_s
        end
      else
        redirect_to character_url(@character), notice: 'You did not have enough money, you need ' + (cost - @character.silver).to_s + ' more silver'
      end
    else
      item_instance.character = @character
      item_instance.save
      if params[:page] == "item_index"
        redirect_to items_path(anchor: params[:page_location]), notice: 'Items Successfuly Taken'
      else
        redirect_to character_url(@character), notice: 'Items Successfuly Taken'
      end
    end
  end

  def remove_proficiency
    prof = Proficiency.find(params[:proficiency_id])
    @character.proficiencies.delete(prof)
    @character.building_points += prof.bp_cost
    @character.save
    redirect_to character_url(@character), notice: 'You no longer have the proficiency ' + prof.name
  end

  def add_proficiency
    prof = Proficiency.find(params[:proficiency_id])
    if @character.building_points > prof.bp_cost
      @character.proficiencies << prof
      @character.building_points -= prof.bp_cost
      @character.save
      redirect_to character_url(@character), notice: 'You now have the proficiency ' + prof.name + '!'
    else
      redirect_to character_url(@character), notice: 'You do not have enough building points for the proficiency ' + prof.name + '!'
    end
  end

  def equip_items
    left = params[:character][:left_hand_item_id]
    left = nil if left == ""
    right = params[:character][:right_hand_item_id]
    right = nil if right == ""
    body = params[:character][:body_item_id]
    body = nil if body == ""
    @character.left_hand_item = @character.item_instances.find(left) if not left.nil?
    @character.right_hand_item = @character.item_instances.find(right) if not right.nil?
    @character.body_item = @character.item_instances.find(body) if not body.nil?
    @character.save
    redirect_to character_url(@character), notice: 'Items Successfuly Equiped'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def character_params
      params.require(:character).permit(
        :id,
        :exp,
        :name,
        :strength,
        :intelligence,
        :wisdom,
        :dexterity,
        :constitution,
        :looks,
        :charisma,
        :building_points,
        :health,
        :item_ids,
        :character_class_id,
        :race_id,
        :user_id,
        :alignment,
        :sex,
        :age,
        :height,
        :weight,
        :hair,
        :eyes,
        :handedness,
        :trade_coins,
        :copper,
        :silver,
        :gold,
        :spell_points,
        :luck_points
      )
    end
end
