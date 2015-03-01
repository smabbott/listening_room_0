class IpsController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: :presence_event
  
  def presence_event
    puts "----------------------------------"
    puts "catch presence event"
    # TODO: create an ip or user given pusher subscription webhook

    puts params
    render nothing: true, status: 200
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