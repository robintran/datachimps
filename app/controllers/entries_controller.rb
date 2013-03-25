class EntriesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_contest
  before_filter :find_entry, except: [:index, :new, :create]
  before_filter :verify_ownership, only: [:edit, :update, :destroy]
  before_filter :verify_contest_ownership, only: [:rate, :remove]
  before_filter :verify_submission_permission, only: [:new]
  before_filter :verify_view_permission, only: [:show]
  # GET /entries
  # GET /entries.json
  def index
    @entries = @contest.entries.active

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = @contest.entries.new(params[:entry].merge(user: current_user))

    respond_to do |format|
      if @entry.save
        format.html { redirect_to contest_entry_url(@contest, @entry), notice: 'Entry was successfully created.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to contest_entry_url(@contest, @entry), notice: 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def rate
    @entry.rate(params[:stars], current_user, params[:dimension])
    respond_to do |format|
      format.html { redirect_to contest_entry_url(@contest, @entry) }
      format.js { render layout: false }
    end
  end

  def remove
    @entry.remove
    redirect_to contest_url(@contest)
  end

  def pick_winning
    if @contest.pick_winner(@entry)
      flash[:notice] = "Prize awarded to winner"
    else
      flash[:error] = "Error picking winner"
    end
    redirect_to contest_entry_url(@contest, @entry)
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to contest_entries_url(@contest) }
      format.json { head :no_content }
    end
  end

  private
  def find_contest
    @contest = Contest.find(params[:contest_id])
  end

  def find_entry
    @entry = Entry.find(params[:id])
  end

  def verify_ownership
    unless current_user == @entry.user
      redirect_to root_path
      return
    end
  end

  def verify_contest_ownership
    unless current_user == @contest.user
      redirect_to root_path
      return
    end
  end

  def verify_submission_permission
    if current_user == @contest.user
      redirect_to contest_path(@contest), notice: 'Cannot enter your own contest.'
    elsif @contest.entries.exists?(user_id: current_user.id)
      redirect_to contest_path(@contest), notice: 'You cannot enter contest twice.'
    end
  end

  def verify_view_permission
    unless current_user == @contest.user || current_user == @entry.user
      redirect_to contest_path(@contest), notice: 'You cannot view other submitted entries'
    end
  end
end
