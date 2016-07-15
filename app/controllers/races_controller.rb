class RacesController < ApplicationController
  before_action :set_race, only: [:show, :edit, :update, :destroy]

  # GET /races
  # GET /races.json
  def index
    @characters = current_user.characters
    @current_character = nil
    @races = Race.all
  end

  # GET /races/1
  # GET /races/1.json
  def show
  end

  # GET /races/new
  def new
    @race = Race.new
  end

  # GET /races/1/edit
  def edit
  end

  # POST /races
  # POST /races.json
  def create
    @race = Race.new(race_params)

    respond_to do |format|
      if @race.save
        format.html { redirect_to @race, notice: 'Race was successfully created.' }
        format.json { render :show, status: :created, location: @race }
      else
        format.html { render :new }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /races/1
  # PATCH/PUT /races/1.json
  def update
    if not params[:skill_counts].nil?
      params[:skill_counts].each do |id_count|
        id = id_count[0]
        count = id_count[1]
        races_skill = RacesSkill.find(id)
        races_skill.count = count
        races_skill.save
      end
    end

    if not params[:talent_percent_costs].nil?
      params[:talent_percent_costs].each do |id_cost|
        id = id_cost[0]
        cost = id_cost[1]
        pref_races_talent = PreferentialRacesTalent.find(id)
        pref_races_talent.percent_cost = cost
        pref_races_talent.save
      end
    end

    respond_to do |format|
      if @race.update(race_params)
        format.html { redirect_to @race, notice: 'Race was successfully updated.' }
        format.json { render :show, status: :ok, location: @race }
      else
        format.html { render :edit }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /races/1
  # DELETE /races/1.json
  def destroy
    @race.destroy
    respond_to do |format|
      format.html { redirect_to races_url, notice: 'Race was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_race
      @race = Race.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def race_params
      params.require(:race).permit(
        :name,
        :description,
        :str_mod,
        :int_mod,
        :wis_mod,
        :dex_mod,
        :con_mod,
        :lks_mod,
        :cha_mod,
        :hp_size_adjustment,
        :defense_adjustment_vs_large,
        :defense_adjustment,
        :hide_in_natural,
        :base_movement,
        :reach_adjustment,
        :size,
        :knock_back_size,
        :low_light_vision,
        :init_die_bonus,
        :male_height,
        :female_height,
        :male_weight,
        :female_weight,
        :lifespan,
        talent_ids: [],
        preferential_talent_ids: [],
        proficiency_ids: [],
        skill_ids: []
      )
    end
end
