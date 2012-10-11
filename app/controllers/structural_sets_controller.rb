class StructuralSetsController < ApplicationController
  include Hydra::AssetsControllerHelper
  include Hydra::AccessControlsEnforcement
  # GET /structural_sets
  # GET /structural_sets.json
  def index
    @structural_sets = StructuralSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @structural_sets }
    end
  end

  # GET /structural_sets/1
  # GET /structural_sets/1.json
  def show
    debugger
    @structural_set = StructuralSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @structural_set }
    end
  end

  # GET /structural_sets/new
  # GET /structural_sets/new.json
  def new
    @structural_set = StructuralSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @structural_set }
    end
  end

  # GET /structural_sets/1/edit
  def edit
    @structural_set = StructuralSet.find(params[:id])
  end 

  # POST /structural_sets
  # POST /structural_sets.json
  def create
    @structural_set = StructuralSet.new(params[:structural_set])

    apply_depositor_metadata(@structural_set)
    @structural_set.label = params[:structural_set][:title]

    respond_to do |format|
      if @structural_set.save
        format.html { redirect_to @structural_set, notice: 'Structural set was successfully created.' }
        format.json { render json: @structural_set, status: :created, location: @structural_set }
      else
        format.html { render action: "new" }
        format.json { render json: @structural_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /structural_sets/1
  # PUT /structural_sets/1.json
  def update
    @structural_set = StructuralSet.find(params[:id])

    respond_to do |format|
      if @structural_set.update_attributes(params[:structural_set])
        format.html { redirect_to @structural_set, notice: 'Structural set was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @structural_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /structural_sets/1
  # DELETE /structural_sets/1.json
  def destroy
    @structural_set = StructuralSet.find(params[:id])
    @structural_set.destroy

    respond_to do |format|
      format.html { redirect_to structural_sets_url }
      format.json { head :no_content }
    end
  end
end
