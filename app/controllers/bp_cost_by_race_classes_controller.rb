class BpCostByRaceClassesController < ApplicationController
  before_action :set_bp_cost_by_race_class, only: [:show, :edit, :update, :destroy]

  # GET /bp_cost_by_race_classes
  # GET /bp_cost_by_race_classes.json
  def index
    @bp_cost_by_race_classes = BpCostByRaceClass.all
    @classes = CharacterClass.all
    @races = Race.all
  end

  # GET /bp_cost_by_race_classes/1
  # GET /bp_cost_by_race_classes/1.json
  def show
  end

  # GET /bp_cost_by_race_classes/new
  def new
    @bp_cost_by_race_class = BpCostByRaceClass.new
  end

  # GET /bp_cost_by_race_classes/1/edit
  def edit
  end

  # POST /bp_cost_by_race_classes
  # POST /bp_cost_by_race_classes.json
  def create
    @bp_cost_by_race_class = BpCostByRaceClass.new(bp_cost_by_race_class_params)

    respond_to do |format|
      if @bp_cost_by_race_class.save
        format.html { redirect_to @bp_cost_by_race_class, notice: 'Bp cost by race class was successfully created.' }
        format.json { render :show, status: :created, location: @bp_cost_by_race_class }
      else
        format.html { render :new }
        format.json { render json: @bp_cost_by_race_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bp_cost_by_race_classes/1
  # PATCH/PUT /bp_cost_by_race_classes/1.json
  def update
    respond_to do |format|
      if @bp_cost_by_race_class.update(bp_cost_by_race_class_params)
        format.html { redirect_to @bp_cost_by_race_class, notice: 'Bp cost by race class was successfully updated.' }
        format.json { render :show, status: :ok, location: @bp_cost_by_race_class }
      else
        format.html { render :edit }
        format.json { render json: @bp_cost_by_race_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bp_cost_by_race_classes/1
  # DELETE /bp_cost_by_race_classes/1.json
  def destroy
    @bp_cost_by_race_class.destroy
    respond_to do |format|
      format.html { redirect_to bp_cost_by_race_classes_url, notice: 'Bp cost by race class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bp_cost_by_race_class
      @bp_cost_by_race_class = BpCostByRaceClass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bp_cost_by_race_class_params
      params.require(:bp_cost_by_race_class).permit(
        :character_class_id,
        :race_id,
        :bp_cost
      )
    end
end
