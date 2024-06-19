class RobotsController < ApplicationController
  def index

    render json: Robot.all
  end
end
