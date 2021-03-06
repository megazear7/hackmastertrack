class CharactersController < ApplicationController
  include Downloadable
  before_action :set_character, only: [:show, :edit, :update, :destroy, :level_up_edit, :level_up_update, :add_xp, :boost_stat, :add_items, :equip_items, :add_proficiency, :remove_proficiency, :add_spell, :add_talent, :add_silver, :step3, :step4, :step5, :step6, :step7, :step8, :step9, :step10, :step11, :step12, :step13, :finish, :leave, :download]

  # GET /characters
  # GET /characters.json
  def index
    if params.has_key?("ids")
        @characters = current_user.characters.where(id: params["ids"].split(","));
    else
        @characters = current_user.characters
    end

    @current_character = nil
    cookies.delete :character_id
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    cookies[:character_id] = @character.id
    @current_character = @character
    @combat_rose = @character.calculate_combat_rose({
      "right_hand" => @character.right_hand_item,
      "left_hand" => @character.left_hand_item,
      "body" => @character.body_item
    })
    @new_item_set = ItemSet.new
    @specialization = Specialization.new
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
    @character.give_class_benefits
    @character.give_race_benefits
    @character.level = 1
    
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
    @character.strength     ||= 0
    @character.intelligence ||= 0
    @character.wisdom       ||= 0
    @character.dexterity    ||= 0
    @character.constitution ||= 0
    @character.charisma     ||= 0
    @character.health       ||= 0

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
    item_to_take = Item.find(params[:character][:item_to_take])
    item_instance = ItemInstance.new
    item_instance.item = item_to_take
    if params[:commit] == "Buy Item"
      cost = item_instance.item.buy_cost
      if @character.silver >= cost
        @character.silver -= cost
        @character.save
        item_instance.character = @character
        item_instance.save
        if params[:page] == "item_index"
          redirect_to items_path, notice: item_to_take.name + ' purchased, total cost was: ' + cost.to_s + ' silver'
        else
          redirect_to items_path, notice: item_to_take.name + ' purchased, total cost was: ' + cost.to_s + ' silver'
        end
      else
        redirect_to items_path, notice: 'You did not have enough money to buy a ' + item_to_take.name + ', you need ' + (cost - @character.silver).to_s + ' more silver'
      end
    else
      item_instance.character = @character
      item_instance.display = false
      item_instance.save
      if params[:page] == "item_index"
        redirect_to items_path(anchor: params[:page_location]), notice: item_to_take.name + ' Taken'
      else
        redirect_to character_url(@character), notice: item_to_take.name + ' Taken'
      end
    end
  end

  def remove_proficiency
    prof = Proficiency.find(params[:proficiency_id])
    @character.proficiencies.delete(prof)
    @character.building_points += prof.bp_cost
    @character.save
    redirect_to proficiencies_path, notice: 'You no longer have the proficiency ' + prof.name
  end

  def add_proficiency
    prof = Proficiency.find(params[:proficiency_id])
    if @character.building_points >= prof.bp_cost and not @character.proficiencies.include? prof
      @character.proficiencies << prof
      @character.building_points -= prof.bp_cost
      @character.save
      redirect_to proficiencies_path, notice: 'You now have the proficiency ' + prof.name + '!'
    elsif @character.proficiencies.include? prof
      redirect_to proficiencies_path, notice: 'You already have the proficiency ' + prof.name + '!'
    else
      redirect_to proficiencies_path, notice: 'You do not have enough building points for the proficiency ' + prof.name + '!'
    end
  end

  def add_spell
    spell = Spell.find(params[:spell_id])
    if not @character.has_spell?(spell)
      char_spell = CharacterSpell.new(spell_id: spell.id, character_id: @character.id)
      if char_spell.save
        redirect_to class_spells_path, notice: 'You now have ' + spell.name + ' in your spellbook!'
      else
        redirect_to class_spells_path, notice: 'There was an error adding ' + spell.name + ' to your spell book!'
      end
    else
      redirect_to class_spells_path, notice: 'You already have ' + spell.name + ' in your spellbook!'
    end
  end

  def boost_stat
    bps = params[:bp_boost].to_i
      if @character.building_points >= bps
      stat = params[:stat]
      current = @character.send(stat)
      if current < 10
        percent = bps * 10
      elsif current < 15
        percent = bps * 5
      else
        percent = bps * 3
      end

      percent = percent.to_f / 100.to_f
      current += percent
      @character.send(stat+"=", current)
      @character.building_points -= bps
      if @character.save
        redirect_to character_url(@character), notice: percent.to_s + ' was added to ' + stat
      else
        redirect_to character_url(@character), notice: 'There was a problem boosting your ' + stat
      end
    else
      redirect_to character_url(@character), notice: 'You did not have enough building points'
    end
  end

  def add_silver
    @character.silver += params[:silver].to_i
    if @character.save
      redirect_to character_url(@character, tab: "equipment"), notice: params[:silver] + ' silver was added. You now have ' + @character.silver.to_s + ' silver.'
    else
      redirect_to character_url(@character, tab: "equipment"), notice: 'There was a problem adding silver.'
    end
  end

  def add_skill
    skill = Skill.find(params[:skill_id])

    if params[:character_id].nil?
      @character = Character.find(params[:id])
    else
      @character = Character.find(params[:character_id])
    end

    if @character.building_points >= skill.bp_cost
        skill_level = @character.add_skill(skill, params[:value].to_i)
        @character.building_points -= skill.bp_cost
        @character.save
        redirect_to skills_path, notice: 'You now have a ' + skill_level.to_s + ' score in the skill ' + skill.name
    else
      redirect_to skills_path, notice: 'You do not have enough building points for the talent ' + skill.name + '!'
    end
  end

  def add_talent
    talent = Talent.find(params[:talent_id])

    if not params[:character_id].nil?
      @character = Character.find(params[:character_id])
    end

    cost = talent.adj_bp_cost(@character.race)

    if talent.item_specific
      if @character.building_points >= cost
        item = Item.find(params[:item][:id])
        char_tal = CharactersTalent.create(talent_id: talent.id, item_id: item.id, character_id: @character.id)
        @character.building_points -= cost
        @character.save
        redirect_to talents_path, notice: 'You now have the talent ' + talent.name + ' (' + char_tal.item.name + ')!'
      else
        redirect_to talents_path, notice: 'You do not have enough building points for the talent ' + talent.name + '!'
      end
    else
      if @character.building_points >= cost and not @character.talents.include? talent
        @character.characters_talents.new(talent_id: talent.id, character_id: @character.id)
        @character.building_points -= cost
        @character.save
        redirect_to talents_path, notice: 'You now have the talent ' + talent.name + '!'
      elsif @character.talents.include? talent
        redirect_to talents_path, notice: 'You already have the talent ' + talent.name + '!'
      else
        redirect_to talents_path, notice: 'You do not have enough building points for the talent ' + talent.name + '!'
      end
    end
  end

  def equip_items
    case params[:location]
    when "body_item"
      loc = "body_item"
    when "left_hand_item"
      loc = "left_hand_item"
    when "right_hand_item"
      loc = "right_hand_item"
    end

    do_equip = false
    if not loc.nil? and @character.item_instances.exists? params[:character][loc+"_id"]
      item = @character.item_instances.find(params[:character][loc+"_id"])
      if item.item.two_handed or (@character.race.size == "s" and not @character.race.name == "Elf" and item.item.size == "m")
        # small races (except for elf) treat medium size weapons as two handed
        @character.off_hand_item = nil
      end

      if loc.include? @character.off_hand and @character.main_hand_item and @character.main_hand_item.item.two_handed
        @character.main_hand_item = nil 
      end

      if item.equiped?
        case item.id
        when @character.main_hand_item.id
          @character.main_hand_item = nil
        when @character.off_hand_item.id
          @character.off_hand_item = nil
        end
      end

      do_equip = true
    elsif not loc.nil?
      do_equip = true
      item = nil
    end

    if do_equip
      if not item.nil?
        message = item.actual_name + " equiped."
      else
        message = ""
      end
      case params[:location]
      when "body_item"
        if item.nil? and @character.body_item
          message = @character.body_item.actual_name + " unequiped."
        end
        @character.body_item = item
      when "left_hand_item"
        if item.nil? and @character.left_hand_item
          message = @character.left_hand_item.actual_name + " unequiped."
        end
        @character.left_hand_item = item
      when "right_hand_item"
        if item.nil? and @character.right_hand_item
          message = @character.right_hand_item.actual_name + " unequiped."
        end
        @character.right_hand_item = item
      end

      if @character.save
        redirect_to character_url(@character, tab: "equipment"), notice: message
      else
        redirect_to character_url(@character, tab: "equipment"), notice: 'Error saving character.'
      end
    else
      redirect_to character_url(@character, tab: "equipment")
    end
  end

  def step1
    @character = Character.new()
    render layout: "character_creation"
  end

  def step2
    @character = Character.new(character_params)
    if @character.save
      render layout: "character_creation"
    else
    end
  end

  def step3
    @character.update(character_params)
    if @character.save
      render layout: "character_creation"
    else
    end
  end

  def step4
    @character.building_points += params["character"]["building_points"].to_f
    @character.strength = params["character"]["strength"].to_f
    @character.intelligence = params["character"]["intelligence"].to_f
    @character.wisdom = params["character"]["wisdom"].to_f
    @character.dexterity = params["character"]["dexterity"].to_f
    @character.constitution = params["character"]["constitution"].to_f
    @character.looks = params["character"]["looks"].to_f
    @character.charisma = params["character"]["charisma"].to_f

    if @character.save
      render layout: "character_creation"
    else
    end
  end

  def step5
    @oldStats = { }
    @oldStats["strength"] = @character.strength
    @oldStats["intelligence"] = @character.intelligence
    @oldStats["wisdom"] = @character.wisdom
    @oldStats["dexterity"] = @character.dexterity
    @oldStats["constitution"] = @character.constitution
    @oldStats["looks"] = @character.looks
    @oldStats["charisma"] = @character.charisma

    @character.update(character_params)
    @character.strength += @character.race.str_mod
    @character.intelligence += @character.race.int_mod
    @character.wisdom += @character.race.wis_mod
    @character.dexterity += @character.race.dex_mod
    @character.constitution += @character.race.con_mod
    @character.looks += @character.race.lks_mod
    @character.charisma += @character.race.cha_mod

    @character.strength = 0 if @character.strength < 0
    @character.intelligence = 0 if @character.intelligence < 0
    @character.wisdom = 0 if @character.wisdom < 0
    @character.dexterity = 0 if @character.dexterity < 0
    @character.constitution = 0 if @character.constitution < 0
    @character.looks = 0 if @character.looks < 0
    @character.charisma = 0 if @character.charisma < 0

    @character.race.proficiencies.each do |prof|
      @character.proficiencies << prof
    end

    @character.race.talents.each do |talent|
      @character.talents << talent
    end

    @character.character_class.proficiencies.each do |prof|
      @character.proficiencies << prof
    end

    @character.character_class.talents.each do |talent|
      @character.talents << talent
    end

    if @character.save
      render layout: "character_creation"
    end
  end

  def step6
    honor = @character.strength
    honor += @character.strength
    honor += @character.intelligence
    honor += @character.wisdom
    honor += @character.dexterity
    honor += @character.constitution
    honor += @character.looks
    honor += @character.charisma

    honor = honor / 7

    @character.honor = honor

    @character.save

    render layout: "character_creation"
  end

  def step7
    render layout: "character_creation"
  end

  def step8
    @character.update(character_params)
    if @character.save
      render layout: "character_creation"
    else
    end
  end

  def step9
    render layout: "character_creation"
  end

  def step10
    if params[:race_skills]
      params[:race_skills].each do |id_value|
        skill = Skill.find(id_value[0])
        value = id_value[1]
        @character.add_skill(skill, value.to_i)
      end
    end

    if params[:character_class_skills]
      params[:character_class_skills].each do |id_value|
        skill = Skill.find(id_value[0])
        value = id_value[1]
        @character.add_skill(skill, value.to_i)
      end
    end

    render layout: "character_creation"
  end

  def step11
    @character.update(character_params)
    if @character.save
      render layout: "character_creation"
    else
    end
  end

  def step12
    render layout: "character_creation"
  end

  def step13
    @character.update(character_params)
    @items = Item.all
    if @character.save
      render layout: "character_creation"
    else
    end
 end

  def finish
    # 1) deal with the post data step13 sends
    # 2) mark the character as "finished", and if the character does not get marked as finished then dont show it anywhere in the application
    # 3) redirect to character show page
    @character.update(character_params)
    @character.finished = true
    if @character.save
       redirect_to @character, notice: 'Character was successfully created.'
    end
 end

 def leave
   @character.destroy
   redirect_to characters_url, notice: 'The character was unfinished and so was destroyed.'
 end

 def download
   send_to_user filepath: @character.generate_pdf
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
