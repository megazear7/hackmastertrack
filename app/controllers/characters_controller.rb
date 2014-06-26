class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :edit, :update, :destroy]

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
    @character = Character.find(params[:character_id])
  end

  def level_up_update
    @character = Character.find(params[:character_id])

    @character.strength     += params[:character][:strength].to_f/100
    @character.intelligence += params[:character][:strength].to_f/100
    @character.wisdom       += params[:character][:strength].to_f/100
    @character.dexterity    += params[:character][:strength].to_f/100
    @character.constitution += params[:character][:strength].to_f/100
    @character.charisma     += params[:character][:strength].to_f/100

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
    @character = Character.find(params[:character_id])
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
        :building_points,
        :charisma
      )
    end
end
