class SpellsController < ApplicationController
  before_action :set_spell, only: [:show, :edit, :update, :destroy]

  # GET /spells
  # GET /spells.json
  def index
    @spells = Spell.all
  end

  # GET /spells/1
  # GET /spells/1.json
  def show
  end

  # GET /spells/new
  def new
    @spell = Spell.new
  end

  # GET /spells/1/edit
  def edit
  end

  # POST /spells
  # POST /spells.json
  def create
    @spell = Spell.new(spell_params)

    respond_to do |format|
      if @spell.save
        format.html { redirect_to @spell, notice: 'Spell was successfully created.' }
        format.json { render :show, status: :created, location: @spell }
      else
        format.html { render :new }
        format.json { render json: @spell.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spells/1
  # PATCH/PUT /spells/1.json
  def update
    respond_to do |format|
      if @spell.update(spell_params)
        format.html { redirect_to @spell, notice: 'Spell was successfully updated.' }
        format.json { render :show, status: :ok, location: @spell }
      else
        format.html { render :edit }
        format.json { render json: @spell.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spells/1
  # DELETE /spells/1.json
  def destroy
    @spell.destroy
    respond_to do |format|
      format.html { redirect_to spells_url, notice: 'Spell was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spell
      @spell = Spell.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spell_params
      params.require(:spell).permit(
        :name,
        :description,
        :spellpoints,
        :spell_type,
        :verbal,
        :somatic,
        :material_component,
        :casting_time,
        :duration,
        :duration_increase,
        :duration_increase_cost,
        :volume_of_effect_type,
        :volume_of_effect,
        :volume_increase,
        :volume_increase_cost,
        :range,
        :range_increase,
        :range_increase_cost,
        :target_damage,
        :target_damage_increase,
        :target_damage_increase_cost,
        :area_damage,
        :area_damage_increase,
        :area_damage_increase_cost,
        :special_increase1,
        :special_increase1_cost,
        :special_increase2,
        :special_increase2_cost,
        :saving_throw,
        :saving_throw_result,
        :bounce_damage,
        :damage_type
      )
    end
end
