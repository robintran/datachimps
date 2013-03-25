class ContestFollowingsController < ApplicationController
  before_filter :authenticate_user!
  # GET /contest_followings
  # GET /contest_followings.json
  def index
    @contest_followings = current_user.contest_followings.includes(:contest)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contest_followings }
    end
  end

  # POST /contest_followings
  # POST /contest_followings.json
  def create
    @contest_following = current_user.contest_followings.new(params[:contest_following])
    respond_to do |format|
      if @contest_following.save
        format.html { redirect_to contest_followings_path, notice: 'Following contest succesfully' }
        format.json { render json: @contest_following, status: :created, location: @contest_following }
      else
        format.html { redirect_to contests_path, notice: @contest_following.errors.full_messages.first }
        format.json { render json: @contest_following.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /contest_followings/1
  # DELETE /contest_followings/1.json
  def destroy
    @contest_following = current_user.contest_followings.find(params[:id])
    @contest_following.destroy

    respond_to do |format|
      format.html { redirect_to contests_path, notice: 'Unfollowing contest successfully' }
      format.json { head :no_content }
    end
  end
end
