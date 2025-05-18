# frozen_string_literal: true

class MessagesController < ApplicationController
before_action :authenticate_user!, only: [:protected, :admin]
  def public
    @message = MessagesService.call(Message::PUBLIC)
  end

  def protected
    @message = MessagesService.call(Message::PROTECTED)
  end

  def admin
    @message = MessagesService.call(Message::ADMIN, session[:credentials][:access_token])
  end
end