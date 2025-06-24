class UnitsController < ApplicationController

  def show
    @unit = Unit.find(params[:id])
  end

  def index
    @units = Unit.all
  end

end
