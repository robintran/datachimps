class ContestsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_filter :find_contest, only: [:show, :edit, :update, :destroy]
  before_filter :verify_ownership, only: [:update, :destroy]

  # GET /contests
  # GET /contests.json
  def index
    @contests = Contest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contests }
    end
  end

  # GET /contests/1
  # GET /contests/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contest }
    end
  end

  # GET /contests/new
  # GET /contests/new.json
  def new
    @contest = Contest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contest }
    end
  end

  # GET /contests/1/edit
  def edit
  end

  # POST /contests
  # POST /contests.json
  def create
    @contest = current_user.contests.new(params[:contest])

    respond_to do |format|
      if @contest.save
        format.html { redirect_to @contest, notice: 'Contest was successfully created.' }
        format.json { render json: @contest, status: :created, location: @contest }
      else
        format.html { render action: "new" }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contests/1
  # PUT /contests/1.json
  def update
    respond_to do |format|
      if @contest.update_attributes(params[:contest])
        format.html { redirect_to @contest, notice: 'Contest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    @contest.destroy

    respond_to do |format|
      format.html { redirect_to contests_url }
      format.json { head :no_content }
    end
  end

  private
  def find_contest
    @contest = Contest.find(params[:id])
  end

  def verify_ownership
    unless current_user == @contest.user
      flash[:notice] = "You do not own this contest"
      redirect_to root_path
      return
    end
  end
end
