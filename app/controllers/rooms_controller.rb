class RoomsController < ApplicationController
  def index
    @current_ip = Ip.find_or_create_by(address: request.ip)
    @ips = Ip.all
    logger.debug 'send update notification'
    Pusher['room_1'].trigger('update', {
      notes: @ips
    })
  end

  def delete
  end
end
