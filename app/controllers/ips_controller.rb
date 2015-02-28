class IpsController < ApplicationController
  
  def presence_event
    puts "----------------------------------"
    puts "catch presence event"
    # TODO: create an ip or user given pusher subscription webhook
  end

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