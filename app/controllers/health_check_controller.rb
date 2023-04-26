class HealthCheckController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    respond_to do |format|
      format.html { render plain: 'OK'}
      format.json { render json: { status: 'OK' } }
    end
  end
end

