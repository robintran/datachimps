class FeedbacksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_contest
  before_filter :find_entry
  before_filter :find_feedback, only: [:update, :destroy]
  before_filter :verify_feedback_ownership, only: [:update, :destroy]
  before_filter :verify_feedback_post_right, only: [:create]

  def new
    @feedback = @entry.feedbacks.new
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = @entry.feedbacks.new(params[:feedback].merge(user: current_user))

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to contest_entry_url(@contest, @entry), notice: 'Feedback was successfully created.' }
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { redirect_to contest_entry_url(@contest, @entry), notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to contest_entry_url(@contest, @entry) }
      format.json { head :no_content }
    end
  end
  private
  def find_contest
    @contest = Contest.find(params[:contest_id])
  end

  def find_entry
    @entry = Entry.find(params[:entry_id])
  end

  def find_feedback
    @feedback = Feedback.find(params[:id])
  end

  def verify_feedback_post_right
    unless current_user == @entry.user || current_user == @contest.user
      redirect_to root_path
      return
    end
  end

  def verify_feedback_ownership
    unless current_user == @feedback.user
      redirect_to root_path
      return
    end
  end
end
