class CharacterSpellsController < ApplicationController
  before_action :set_character_spell, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @character_spells = CharacterSpell.all
    respond_with(@character_spells)
  end

  def show
    respond_with(@character_spell)
  end

  def new
    @character_spell = CharacterSpell.new
    respond_with(@character_spell)
  end

  def edit
  end

  def create
    @character_spell = CharacterSpell.new(character_spell_params)
    @character_spell.save
    respond_with(@character_spell)
  end

  def update
    @character_spell.update(character_spell_params)
    respond_with(@character_spell)
  end

  def destroy
    @character_spell.destroy
    respond_with(@character_spell)
  end

  private
    def set_character_spell
      @character_spell = CharacterSpell.find(params[:id])
    end

    def character_spell_params
      params[:character_spell]
    end
end
