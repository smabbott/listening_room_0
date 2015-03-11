class VoicesController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: :presence_event
  
  # def presence_event
  #   puts "----------------------------------"
  #   puts "catch presence event"
  #   # todo: different things depending on event
  #   params["events"].each do |event|
  #     case event["name"]
  #     when "member_added"
  #       # broadcast member_added to 
  #     end
  #     params["events"]["voice"]
  #   end

  #   puts params
  #   render nothing: true, status: 200
  # end

  def delete
    puts "------------- ips controller: delete"
    Voice.destroy params[:id]

    # @ips = Ip.all
    # # TODO: abstract to concern
    # Pusher['presence-room-1'].trigger('update', {
    #   notes: @ips
    # })
    # redirect :back
    render json:{head: :ok}
  end
end