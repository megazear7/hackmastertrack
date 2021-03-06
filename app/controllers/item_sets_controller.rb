class ItemSetsController < ApplicationController
  before_action :set_item_set, only: [:remove_worn_item, :add_worn_item, :update, :destroy]

  # POST /item_sets
  # POST /item_sets.json
  def create
    @item_set = ItemSet.new(item_set_params)

    respond_to do |format|
      if @item_set.save
        format.html { redirect_to character_path(@item_set.character, tab: "combat"), notice: 'Item set was successfully created.' }
      else
        format.html { redirect_to character_path(@item_set.character, tab: "combat"), notice: 'Error during creation of item set.' }
      end
    end
  end

  def remove_worn_item
    item_instance = ItemInstance.find(params[:item_set][:item_instance_id])
    if item_instance and @item_set.item_instances.delete(item_instance)
      redirect_to character_path(@item_set.character, tab: "combat"), notice: 'Item was removed from worn items list.'
    else
      redirect_to character_path(@item_set.character, tab: "combat"), notice: 'Error removing item from worn items list .'
    end
  end

  def add_worn_item
    item_instance = ItemInstance.find(params[:item_set][:item_instance_id])
    if item_instance and @item_set.item_instances << item_instance
      redirect_to character_path(@item_set.character, tab: "combat"), notice: 'Item was added to worn items list.'
    else
      redirect_to character_path(@item_set.character, tab: "combat"), notice: 'Error adding item to worn items list .'
    end
  end

  # PATCH/PUT /item_sets/1
  # PATCH/PUT /item_sets/1.json
  def update
    respond_to do |format|
      if @item_set.update(item_set_params)
        format.html { redirect_to character_path(@item_set.character, tab: "combat"), notice: 'Item set was successfully updated.' }
      else
        format.html { redirect_to character_path(@item_set.character, tab: "combat"), notice: 'Error during update of item set.' }
      end
    end
  end

  # DELETE /item_sets/1 
  # DELETE /item_sets/1.json 
  def destroy
    session[:return_to] ||= request.referer
    @item_set.destroy
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), notice: 'Item set was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_set
      @item_set = ItemSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_set_params
      params.require(:item_set).permit(
        :character_id,
        :right_item_id,
        :left_item_id,
        :body_item_id,
        item_instance_ids: []
      )
    end
end
