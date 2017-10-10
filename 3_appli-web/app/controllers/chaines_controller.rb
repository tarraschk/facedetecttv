class ChainesController < ApplicationController
  before_action :set_chaine, only: [:show, :edit, :update, :destroy]

  # GET /chaines
  # GET /chaines.json
  def index
    @chaines = Chaine.all
  end

  # GET /chaines/1
  # GET /chaines/1.json
  def show
  end

  # GET /chaines/new
  def new
    @chaine = Chaine.new
  end

  # GET /chaines/1/edit
  def edit
  end

  # POST /chaines
  # POST /chaines.json
  def create
    @chaine = Chaine.new(chaine_params)

    respond_to do |format|
      if @chaine.save
        format.html { redirect_to @chaine, notice: 'Chaine was successfully created.' }
        format.json { render :show, status: :created, location: @chaine }
      else
        format.html { render :new }
        format.json { render json: @chaine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chaines/1
  # PATCH/PUT /chaines/1.json
  def update
    respond_to do |format|
      if @chaine.update(chaine_params)
        format.html { redirect_to @chaine, notice: 'Chaine was successfully updated.' }
        format.json { render :show, status: :ok, location: @chaine }
      else
        format.html { render :edit }
        format.json { render json: @chaine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chaines/1
  # DELETE /chaines/1.json
  def destroy
    @chaine.destroy
    respond_to do |format|
      format.html { redirect_to chaines_url, notice: 'Chaine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chaine
      @chaine = Chaine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chaine_params
      params.require(:chaine).permit(:name, :parser)
    end
end
