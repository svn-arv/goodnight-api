require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:following_user) { create(:user) }

  describe 'POST #follow' do
    let(:valid_attributes) { { following_id: following_user.id, user_id: user.id } }
    let(:invalid_attributes) { { following_id: user.id, user_id: user.id } }

    context 'with valid parameters' do
      it 'creates a new relationship' do
        post :follow, params: valid_attributes
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post :follow, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #unfollow' do
    let(:valid_attributes) { { following_id: following_user.id, user_id: user.id } }

    context 'with valid parameters' do
      it 'removes the relationship' do
        post :unfollow, params: valid_attributes
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #following_sleep_records' do
    let(:sleep_record_action_class) { class_double(Actions::SleepRecord::Read) }
    let(:following_user) { create(:user) }

    before do
      create(:relationship, user: user, following: following_user)
      create(:sleep_record, user: following_user)
    end

    it 'returns sleep records from followed users within the past week' do
      get :following_sleep_records, params: { user_id: user.id }
      expect(response.body).to be_present
      expect(response).to have_http_status(:ok)
    end
  end
end
