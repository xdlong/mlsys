class LanguageIdentification::Lexicon::CharactersController < ApplicationController
  before_action :set_language_identification_lexicon_character, only: [:show, :edit, :update, :destroy]

  # GET /language_identification/lexicon/characters
  # GET /language_identification/lexicon/characters.json
  def index
    @language_identification_lexicon_characters = (params[:search].present? ? LanguageIdentification::Lexicon::Character.where(contained:params[:search]) : LanguageIdentification::Lexicon::Character.all_character).page(params[:page]).per(params[:per]||10)
  end

  # GET /language_identification/lexicon/characters/1
  # GET /language_identification/lexicon/characters/1.json
  def show
  end

  # GET /language_identification/lexicon/characters/new
  def new
    @language_identification_lexicon_character = LanguageIdentification::Lexicon::Character.new
  end

  # GET /language_identification/lexicon/characters/1/edit
  def edit
  end

  # POST /language_identification/lexicon/characters
  # POST /language_identification/lexicon/characters.json
  def create
    @language_identification_lexicon_character = LanguageIdentification::Lexicon::Character.new(language_identification_lexicon_character_params)

    respond_to do |format|
      if @language_identification_lexicon_character.save
        format.html { redirect_to @language_identification_lexicon_character, notice: 'Character was successfully created.' }
        format.json { render :show, status: :created, location: @language_identification_lexicon_character }
      else
        format.html { render :new }
        format.json { render json: @language_identification_lexicon_character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /language_identification/lexicon/characters/1
  # PATCH/PUT /language_identification/lexicon/characters/1.json
  def update
    respond_to do |format|
      if @language_identification_lexicon_character.update(language_identification_lexicon_character_params)
        format.html { redirect_to @language_identification_lexicon_character, notice: 'Character was successfully updated.' }
        format.json { render :show, status: :ok, location: @language_identification_lexicon_character }
      else
        format.html { render :edit }
        format.json { render json: @language_identification_lexicon_character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /language_identification/lexicon/characters/1
  # DELETE /language_identification/lexicon/characters/1.json
  def destroy
    @language_identification_lexicon_character.destroy
    respond_to do |format|
      format.html { redirect_to language_identification_lexicon_characters_url, notice: 'Character was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_language_identification_lexicon_character
      @language_identification_lexicon_character = LanguageIdentification::Lexicon::Character.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def language_identification_lexicon_character_params
      params.require(:language_identification_lexicon_character).permit(:contained)
    end
end
