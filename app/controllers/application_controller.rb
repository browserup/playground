class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def auto_clean
    # we only clean up once every good while to avoid extra DB load
    return unless rand(50) == 0
    clean
  end

  def clean(room_limit = 10000, room_message_limit = 200, toy_limit = 200, user_limit = 100000)
    Rails.logger.info("Cleaning up old records")
    ActiveRecord::Base.transaction do
      drop_older_records(Room, room_limit) # room limit is high as destroying it during a test run may cause the test to fail
      drop_older_records(RoomMessage, room_message_limit)
      drop_older_records(Toy, toy_limit)
      drop_older_records(User, user_limit) # user limit is high as destroying it during a test run may cause the test to fail
    end
  end

  def drop_older_records(model_klass, limit)
    # Fetch the time the most recent nth record was created
    delete_older_than = model_klass.order(Arel.sql('created_at DESC')).limit(limit).pluck(:created_at).last
    model_klass.destroy_by("created_at < ?", delete_older_than) unless delete_older_than.nil?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username])
  end
end
