class RobotsController < ApplicationController
  def index

    render json: Robo.all
  end
end
