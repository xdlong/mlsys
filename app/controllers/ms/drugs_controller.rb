class Ms::DrugsController < ApplicationController
  before_action :set_ms_drug, only: [:show, :edit, :update, :destroy]
  layout 'ms'

  # GET /ms/drugs
  # GET /ms/drugs.json
  def index
    @ms_drugs = (params[:search].present? ? Ms::Drug.where(name:params[:search]) : Ms::Drug.all).
      page(params[:page]).per(params[:per]||10)
  end

  # GET /ms/drugs/1
  # GET /ms/drugs/1.json
  def show
  end

  # GET /ms/drugs/new
  def new
    @ms_drug = Ms::Drug.new
  end

  # GET /ms/drugs/1/edit
  def edit
  end

  # POST /ms/drugs
  # POST /ms/drugs.json
  def create
    @ms_drug = Ms::Drug.new(ms_drug_params)

    respond_to do |format|
      if @ms_drug.save
        format.html { redirect_to @ms_drug, notice: 'Drug was successfully created.' }
        format.json { render :show, status: :created, location: @ms_drug }
      else
        format.html { render :new }
        format.json { render json: @ms_drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ms/drugs/1
  # PATCH/PUT /ms/drugs/1.json
  def update
    respond_to do |format|
      if @ms_drug.update(ms_drug_params)
        format.html { redirect_to @ms_drug, notice: 'Drug was successfully updated.' }
        format.json { render :show, status: :ok, location: @ms_drug }
      else
        format.html { render :edit }
        format.json { render json: @ms_drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ms/drugs/1
  # DELETE /ms/drugs/1.json
  def destroy
    @ms_drug.destroy
    respond_to do |format|
      format.html { redirect_to ms_drugs_url, notice: 'Drug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ms_drug
      @ms_drug = Ms::Drug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ms_drug_params
      params.require(:ms_drug).permit(:name, :type, :unit, :unit_price, :inventory, :byname, :resume, :notice)
    end
end
