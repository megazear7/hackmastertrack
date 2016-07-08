class ItemInstancesController < ApplicationController
  before_action :set_item_instance, only: [:show, :edit, :update, :destroy]

  # GET /item_instances
  # GET /item_instances.json
  def index
    @characters = current_user.characters
    @current_character = nil
    @item_instances = ItemInstance.where(display: true)
  end

  # GET /item_instances/1
  # GET /item_instances/1.json
  def show
  end

  # GET /item_instances/new
  def new
    @item_instance = ItemInstance.new
    @is_display = true
  end

  # GET /item_instances/1/edit
  def edit
    if @item_instance.display == false
      @is_display = false
    else
      @is_display = true
    end
  end

  def take
    @character = Character.find(params[:character][:id])
    @item_instance = ItemInstance.find(params[:id]).dup
    @item_instance.display = false
    @character.item_instances << @item_instance
    redirect_to item_instances_url
  end

  # POST /item_instances
  # POST /item_instances.json
  def create
    @item_instance = ItemInstance.new(item_instance_params)
    #if @item_instance.display == true
    #  @new_display_item = @item_instance.dup
    #  @new_display_item.save
    #end
    respond_to do |format|
      if @item_instance.save
        format.html { redirect_to @item_instance, notice: 'Item instance was successfully created.' }
        format.json { render :show, status: :created, location: @item_instance }
      else
        format.html { render :new }
        format.json { render json: @item_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_instances/1
  # PATCH/PUT /item_instances/1.json
  def update
    respond_to do |format|
      if @item_instance.update(item_instance_params)
        format.html { redirect_to @item_instance, notice: 'Item instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @item_instance }
      else
        format.html { render :edit }
        format.json { render json: @item_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_instances/1 
  # DELETE /item_instances/1.json 
  def destroy
    session[:return_to] ||= request.referer
    @item_instance.destroy
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), notice: 'Item instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_instance
      @item_instance = ItemInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_instance_params
      params.require(:item_instance).permit(
        :item_id,
        :character_id,
        :durability,
        :attack_mod,
        :speed_mod,
        :init_mod,
        :defense_mod,
        :damage_mod,
        :damage_reduction,
        :magic_level,
        :init_die_mod,
        :name,
        :display
      )
    end
end
