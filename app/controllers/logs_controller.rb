class LogsController < ApplicationController
  before_action :set_unit, only: [:new, :create]

  def show
    @log = Log.find(params[:id])
    #authorize @log
  end

  def index
    @logs = Log.all
  end

   def new
    @log = @unit.logs.build
  end

  def create
    @log = @unit.logs.build(log_params)

    if @log.save
      redirect_to log_path(@log), notice: 'Log was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def set_unit
    @unit = Unit.find(params[:unit_id])
  end

  def log_params
    params.require(:log).permit(:date, :shift_type)
  end

end
