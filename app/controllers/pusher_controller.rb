class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    puts 'auth'
    @current_ip = Ip.find_or_create_by(address: request.ip)
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => @current_ip.id,
      :user_info => {
        :voice => @current_ip.voice
      }
    })
    render :json => response
  end
end