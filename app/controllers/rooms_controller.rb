class RoomsController < ApplicationController
  before_action :load_entities

  after_action :auto_clean, only: [:create, :update]

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(permitted_parameters)
    if @room.save
      flash[:success] = "Room #{@room.name} was created successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def show
    @room_message = RoomMessage.new room: @room
    @room_messages = @room.room_messages.includes(:user)
  end

  def edit
  end

  def update
    if @room.update_attributes(permitted_parameters)
      flash[:success] = "Room #{@room.name} was updated successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  private

  def load_entities
    @rooms = Room.all
    if params[:id]
      if params[:id] == "demo"
        @room = Room.find_by(name: "Demo")
        if @room.nil?
          @room = Room.create(name: "Demo")
        end
      else
        @room = Room.find params[:id]
      end
    end
  end

  def permitted_parameters
    params.require(:room).permit(:name)
  end
end
