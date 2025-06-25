class LogEntriesController < ApplicationController

  def index
    LogEntry.all
  end

  def new
    @log = Log.find(params[:log_id])
    @log_entry = @log.log_entries.build
    @log_entry.user = current_user
  end

  def create
    @log = Log.find(params[:log_id])
    @log_entry = @log.log_entries.build(log_entry_params)
    @log_entry.user = current_user

    if @log_entry.save
      redirect_to log_path(@log), notice: 'Log Entry was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end


  private
  def log_entry_params
    params.require(:log_entry).permit(:content, :entry_type, :section_identifier)
  end
end
