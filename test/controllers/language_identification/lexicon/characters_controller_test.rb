require 'test_helper'

class LanguageIdentification::Lexicon::CharactersControllerTest < ActionController::TestCase
  setup do
    @language_identification_lexicon_character = language_identification_lexicon_characters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:language_identification_lexicon_characters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create language_identification_lexicon_character" do
    assert_difference('LanguageIdentification::Lexicon::Character.count') do
      post :create, language_identification_lexicon_character: { contained: @language_identification_lexicon_character.contained }
    end

    assert_redirected_to language_identification_lexicon_character_path(assigns(:language_identification_lexicon_character))
  end

  test "should show language_identification_lexicon_character" do
    get :show, id: @language_identification_lexicon_character
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @language_identification_lexicon_character
    assert_response :success
  end

  test "should update language_identification_lexicon_character" do
    patch :update, id: @language_identification_lexicon_character, language_identification_lexicon_character: { contained: @language_identification_lexicon_character.contained }
    assert_redirected_to language_identification_lexicon_character_path(assigns(:language_identification_lexicon_character))
  end

  test "should destroy language_identification_lexicon_character" do
    assert_difference('LanguageIdentification::Lexicon::Character.count', -1) do
      delete :destroy, id: @language_identification_lexicon_character
    end

    assert_redirected_to language_identification_lexicon_characters_path
  end
end
