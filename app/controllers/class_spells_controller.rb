class ClassSpellsController < ApplicationController
  before_action :set_class_spell, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @class_spells = ClassSpell.all
    respond_with(@class_spells)
  end

  def show
    respond_with(@class_spell)
  end

  def new
    @class_spell = ClassSpell.new
    respond_with(@class_spell)
  end

  def edit
  end

  def create
    @class_spell = ClassSpell.new(class_spell_params)
    @class_spell.save
    respond_with(@class_spell)
  end

  def update
    @class_spell.update(class_spell_params)
    respond_with(@class_spell)
  end

  def destroy
    @class_spell.destroy
    respond_with(@class_spell)
  end

  private
    def set_class_spell
      @class_spell = ClassSpell.find(params[:id])
    end

    def class_spell_params
      params[:class_spell]
    end
end
