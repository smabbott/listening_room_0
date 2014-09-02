class IpsController < ApplicationController
  def delete
    Ip.destroy params[:id]

    @ips = Ip.all
    # TODO: abstract to concern
    Pusher['room_1'].trigger('update', {
      notes: @ips
    })
    redirect :back
  end
end