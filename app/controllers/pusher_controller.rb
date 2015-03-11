class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    puts "-------------- PusherController"
    puts 'auth'
    @current_voice = Voice.create(address:request.remote_ip)
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => @current_voice.id,
      :user_info => {
        :voice => @current_voice.attributes,
        :ip => @current_voice.address
      }
    })

    render :json => response
  end

end