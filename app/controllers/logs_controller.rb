class LogsController < ApplicationController


  def show
    @log = Log.find(params[:id])
    #authorize @log
  end

  def index
    @logs = Log.all
  end


  private

  def log_params
    params.require(:log).permit(:date, :status, :shift_type, :unit_id)
  end

end
