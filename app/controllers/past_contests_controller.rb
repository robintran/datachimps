class PastContestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @contests = current_user.last_contests
  end
end
