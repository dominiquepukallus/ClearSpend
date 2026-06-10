class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :landing

  def home
  end

  def landing
    redirect_to home_path if user_signed_in?
  end
end
