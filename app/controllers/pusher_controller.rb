class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    puts "-------------- PusherController"
    puts 'auth'
    @current_voice = Voice.create
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => @current_voice.id,
      :user_info => @current_voice.attributes
    })

    render :json => response
  end

end