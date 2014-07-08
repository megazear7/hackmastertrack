class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
    @item_t = ["melee", "polearm", "ranged", "armor", "shield", "consumable", "wearable", "precious" ]
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(
        :item_type,
        :attack_mod,
        :speed_mod,
        :init_mod,
        :defense_mod,
        :damage_mod,
        :damage_reduction,
        :magic_level,
        :weight,
        :cover_value,
        :location,
        :damage,
        :shield_size,
        :armor_type,
        :name,
        :description,
        :attack_speed,
        :jab_speed,
        :reach,
        :buy_cost,
        :sell_value,
        :damage_type,
        :heal_value,
        :high_avail,
        :med_avail,
        :low_avail,
        :init_die_mod,
        :movement_rate_reduction,
        :crouching_cover_value,
        :shield_damage,
        :str_required,
        :skill_level,
        :dismount,
        :hvy_armor,
        :set_for_charge,
        :pole_arm_defense,
        :pole_arm_type,
        :phalanx,
        :size,
        :max_range, 
        :range_short,
        :range_medium,
        :range_long,
        :range_extreme,
        :range_maximum
      )
    end
end
