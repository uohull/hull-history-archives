class GenericContentsController < ApplicationController
  include Hydra::AssetsControllerHelper
  include Hydra::AccessControlsEnforcement
  include Hydra::Controller::UploadBehavior

  before_filter :enforce_access_controls
  # GET /generic_contents
  # GET /generic_contents.json
  def index
    @generic_contents = GenericContent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @generic_contents }
    end
  end

  # GET /generic_contents/1
  # GET /generic_contents/1.json
  def show
    @generic_content = GenericContent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @generic_content }
    end
  end

  # GET /generic_contents/new
  # GET /generic_contents/new.json
  def new
    @generic_content = GenericContent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @generic_content }
    end
  end

  # GET /generic_contents/1/edit
  def edit
    @generic_content = GenericContent.find(params[:id])
  end

  # POST /generic_contents
  # POST /generic_contents.json
  def create
    @generic_content = GenericContent.new(params[:generic_content])
    apply_depositor_metadata(@generic_content)
    @generic_content.label = params[:generic_content][:title]

    add_posted_blob_to_asset(@generic_content, params[:filedata]) if params.has_key?(:filedata)

    respond_to do |format|
      if @generic_content.save
        format.html { redirect_to @generic_content, notice: 'Generic content was successfully created.' }
        format.json { render json: @generic_content, status: :created, location: @generic_content }
      else
        format.html { render action: "new" }
        format.json { render json: @generic_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /generic_contents/1
  # PUT /generic_contents/1.json
  def update
    @generic_content = GenericContent.find(params[:id])

    respond_to do |format|
      if @generic_content.update_attributes(params[:generic_content])
        format.html { redirect_to @generic_content, notice: 'Generic content was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @generic_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /generic_contents/1
  # DELETE /generic_contents/1.json
  def destroy
    @generic_content = GenericContent.find(params[:id])
    @generic_content.destroy

    respond_to do |format|
      format.html { redirect_to generic_contents_url }
      format.json { head :no_content }
    end
  end
end
