class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    puts "-------------- PusherController"
    puts 'auth'
    @current_voice = Voice.create(address:request.remote_ip)
    voice = @current_voice.attributes.reject{|k,v| k.to_sym == :address}
    voice[:digits] = @current_voice.digits
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => @current_voice.id,
      :user_info => {
        :voice => voice,
      }
    })

    render :json => response
  end

end