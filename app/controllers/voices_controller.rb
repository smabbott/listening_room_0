class VoicesController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: :presence_event
  
  def presence_event
    puts "----------------------------------"
    puts "catch presence event"
    # todo: different things depending on event
    params["events"].each do |event|
      if event["name"] == 'member_removed'
        begin
          voice = Voice.find event["user_id"].to_i
          voice.destroy unless voice.blank?
        rescue ActiveRecord::RecordNotFound

        end
      end
      # case event["name"]
      # when "member_added"
      #   # broadcast member_added to 

      # end
    end

    puts params
    render nothing: true, status: 200
  end

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