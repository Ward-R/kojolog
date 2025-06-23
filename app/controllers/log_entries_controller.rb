class LogEntriesController < ApplicationController

  def index
    LogEntry.all
  end
end
