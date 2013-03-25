class PendingContestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @contests = current_user.pending_contests
  end
end
