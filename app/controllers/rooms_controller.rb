class RoomsController < ApplicationController
  def index
    puts "------------- rooms controller index"
    @current_ip = Ip.find_or_create_by(address: request.ip)
    @ips = Ip.all

    Pusher['presence-room-1'].trigger('update', {
      notes: @ips
    })
  end


end
