class AbilityScoresController < ApplicationController
  before_action :set_ability_score, only: [:show, :edit, :update, :destroy]

  # GET /ability_scores
  # GET /ability_scores.json
  def index
    @ability_scores = AbilityScore.all
    @abilities = params[:ability] ? [params[:ability]] : [ "Strength", "Intelligence", "Wisdom", "Dexterity", "Constitution", "Charisma" ]
  end

  # GET /ability_scores/1
  # GET /ability_scores/1.json
  def show
  end

  # GET /ability_scores/new
  def new
    @ability_score = AbilityScore.new
  end

  # GET /ability_scores/1/edit
  def edit
  end

  # POST /ability_scores
  # POST /ability_scores.json
  def create
    @ability_score = AbilityScore.new(ability_score_params)

    respond_to do |format|
      if @ability_score.save
        format.html { redirect_to @ability_score, notice: 'Ability score was successfully created.' }
        format.json { render :show, status: :created, location: @ability_score }
      else
        format.html { render :new }
        format.json { render json: @ability_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ability_scores/1
  # PATCH/PUT /ability_scores/1.json
  def update

    respond_to do |format|
      if @ability_score.update(ability_score_params)
        format.html { redirect_to @ability_score, notice: 'Ability score was successfully updated.' }
        format.json { render :show, status: :ok, location: @ability_score }
      else
        format.html { render :edit }
        format.json { render json: @ability_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ability_scores/1
  # DELETE /ability_scores/1.json
  def destroy
    @ability_score.destroy
    respond_to do |format|
      format.html { redirect_to ability_scores_url, notice: 'Ability score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ability_score
      @ability_score = AbilityScore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ability_score_params
      params.require(:ability_score).permit(
        :ability,
        :min,
        :max,
        :feat_of_strength,
        :lift,
        :carry,
        :drag,
        :damage_mod,
        :init_mod,
        :speed_mod,
        :attack_mod,
        :defense_mod,
        :turning_mod,
        :feat_of_agility,
        :mental_saving_throw_bonus,
        :dodge_saving_throw_bonus,
        :physical_saving_throw_bonus,
        :morale_mod,
        :max_spells_per_level,
        :chance_to_learn_spell
      )
    end
end
