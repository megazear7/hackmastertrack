class ClassSpellsController < ApplicationController
  before_action :set_class_spell, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if not params[:class_id].nil?
      @char_class = CharacterClass.find(params[:class_id])
    elsif @current_character
      @char_class = @current_character.character_class
    end

    if not params[:level].nil?
      @level = params[:level].to_i
    end
  end

  def new
    @class_spell = ClassSpell.new
  end

  def edit
  end

  def create
    @class_spell = ClassSpell.new(class_spell_params)
    @class_spell.save
  end

  def update
    @class_spell.update(class_spell_params)
  end

  def destroy
    @class_spell.destroy
  end

  private
    def set_class_spell
      @class_spell = ClassSpell.find(params[:id])
    end

    def class_spell_params
      params.require(:class_spell).permit(
        :character_class_id,
        :spell_id,
        :level)
    end
end
