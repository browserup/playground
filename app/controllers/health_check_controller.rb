class HealthCheckController < ApplicationController
  def index
    respond_to do |format|
      format.html { render plain: 'OK'}
      format.json { render json: { status: 'OK' } }
    end
  end
end

