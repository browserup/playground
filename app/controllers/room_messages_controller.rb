class RoomMessagesController < ApplicationController
  before_action :sign_in_demo_user_if_needed
  before_action :load_entities

  after_action :auto_clean

  def create
    @room_message = RoomMessage.create user: current_user,
                                       room: @room,
                                       message: params.dig(:room_message, :message)

   RoomChannel.broadcast_to @room, @room_message
  end

  protected

  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end
