class ClassSpellbooksController < ApplicationController
  before_action :set_class_spellbook, only: [:show, :edit, :update, :destroy]

  # GET /class_spellbooks
  # GET /class_spellbooks.json
  def index
    @class_spellbooks = ClassSpellbook.all
    @classes = CharacterClass.all
    @spells = Spell.all

  end

  # GET /class_spellbooks/1
  # GET /class_spellbooks/1.json
  def show
  end

  # GET /class_spellbooks/new
  def new
    @class_spellbook = ClassSpellbook.new
  end

  # GET /class_spellbooks/1/edit
  def edit
  end

  # POST /class_spellbooks
  # POST /class_spellbooks.json
  def create
    @class_spellbook = ClassSpellbook.new(class_spellbook_params)

    respond_to do |format|
      if @class_spellbook.save
        format.html { redirect_to @class_spellbook, notice: 'Class spellbook was successfully created.' }
        format.json { render :show, status: :created, location: @class_spellbook }
      else
        format.html { render :new }
        format.json { render json: @class_spellbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /class_spellbooks/1
  # PATCH/PUT /class_spellbooks/1.json
  def update
    respond_to do |format|
      if @class_spellbook.update(class_spellbook_params)
        format.html { redirect_to @class_spellbook, notice: 'Class spellbook was successfully updated.' }
        format.json { render :show, status: :ok, location: @class_spellbook }
      else
        format.html { render :edit }
        format.json { render json: @class_spellbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /class_spellbooks/1
  # DELETE /class_spellbooks/1.json
  def destroy
    @class_spellbook.destroy
    respond_to do |format|
      format.html { redirect_to class_spellbooks_url, notice: 'Class spellbook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_spellbook
      @class_spellbook = ClassSpellbook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def class_spellbook_params
      params.require(:class_spellbook).permit(:character_class_id, :spell_id, :level)
    end
end
