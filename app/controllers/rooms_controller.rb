class RoomsController < ApplicationController
  def index
    @current_ip = Ip.find_or_create_by(address: request.ip)
    @ips = Ip.all
    # Pusher['room_1'].trigger('update', {
    #   :greeting => "Hello there!"
    # })
  end

  def delete
  end
end
