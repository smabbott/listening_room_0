class IpsController < ApplicationController
  def delete
    puts "------------- ips controller: delete"
    Ip.destroy params[:id]

    @ips = Ip.all
    # TODO: abstract to concern
    Pusher['presence-room-1'].trigger('update', {
      notes: @ips
    })
    redirect :back
  end
end