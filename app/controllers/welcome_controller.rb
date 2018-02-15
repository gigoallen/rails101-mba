class WelcomeController < ApplicationController
  def index
    flash[:notice] = "早安！notice"
    flash[:alert] = "早安！alert"
    flash[:warning] = "早安！warning"
  end
end
