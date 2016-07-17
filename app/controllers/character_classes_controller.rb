class CharacterClassesController < ApplicationController
  before_action :set_character_class, only: [:show, :edit, :update, :destroy]

  # GET /character_classes
  # GET /character_classes.json
  def index
    @characters = current_user.characters
    @current_character = nil
    @character_classes = CharacterClass.all
  end

  # GET /character_classes/1
  # GET /character_classes/1.json
  def show
  end

  # GET /character_classes/new
  def new
    @character_class = CharacterClass.new
  end

  # GET /character_classes/1/edit
  def edit
  end

  # POST /character_classes
  # POST /character_classes.json
  def create
    @character_class = CharacterClass.new(character_class_params)

    respond_to do |format|
      if @character_class.save
        format.html { redirect_to @character_class, notice: 'Character class was successfully created.' }
        format.json { render :show, status: :created, location: @character_class }
      else
        format.html { render :new }
        format.json { render json: @character_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /character_classes/1
  # PATCH/PUT /character_classes/1.json
  def update
    if not params[:skill_counts].nil?
      params[:skill_counts].each do |id_count|
        id = id_count[0]
        count = id_count[1]
        character_classes_skill = CharacterClassesSkill.find(id)
        character_classes_skill.count = count
        character_classes_skill.save
      end
    end

    respond_to do |format|
      if @character_class.update(character_class_params)
        format.html { redirect_to @character_class, notice: 'Character class was successfully updated.' }
        format.json { render :show, status: :ok, location: @character_class }
      else
        format.html { render :edit }
        format.json { render json: @character_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /character_classes/1
  # DELETE /character_classes/1.json
  def destroy
    @character_class.destroy
    respond_to do |format|
      format.html { redirect_to character_classes_url, notice: 'Character class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character_class
      @character_class = CharacterClass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def character_class_params
      params.require(:character_class).permit(
        :name,
        :hit_dice_size,
        :description,
        :attack_specialization_cost,
        :speed_specialization_cost,
        :defense_specialization_cost,
        :damage_specialization_cost,
        :luck_points,
        proficiency_ids: [],
        talent_ids: [],
        skill_ids: []
      )
    end
end
