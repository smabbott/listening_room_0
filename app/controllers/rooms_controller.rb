class RoomsController < ApplicationController
  def index
    puts "------------- rooms controller index"
    # @voices = Voice.all

    # Pusher['presence-room-1'].trigger('update', {
    #   voices: @voices
    # })
  end


end
