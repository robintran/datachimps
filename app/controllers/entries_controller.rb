class EntriesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_contest
  before_filter :find_entry, only: [:edit, :update, :destroy, :add_rating]
  before_filter :verify_ownership, only: [:edit, :update, :destroy]
  before_filter :verify_contest_ownership, only: [:add_rating]
  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all

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
  def edits
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

  def add_rating
    respond_to do |format|
      if @entry.update_rating(params[:rating])
        format.html { redirect_to contest_entry_url(@contest, @entry), notice: 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to contest_entry_url(@contest, @entry), alert: 'Cannot update rating.' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
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
end
