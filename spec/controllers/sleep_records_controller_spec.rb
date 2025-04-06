require 'rails_helper'

RSpec.describe SleepRecordsController, type: :controller do
  let(:user) { create(:user) }
  let(:clock_in_valid_attributes) { { at: Time.current.iso8601, user_id: user.id } }
  let(:clock_in_invalid_attributes) { { at: Time.current.iso8601 } }
  let(:clock_out_valid_attributes) { { at: Time.current.iso8601, sleep_record_id: sleep_record.id, user_id: user.id } }
  let(:clock_out_invalid_attributes) { { at: Time.current.iso8601, user_id: user.id } }
  let(:sleep_record) { create(:sleep_record, user: user) }

  describe 'POST #clock_in' do
    context 'with valid parameters' do
      it 'creates a new sleep record' do
        post :clock_in, params: clock_in_valid_attributes

        expect(JSON.parse(response.body)).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post :clock_in, params: clock_in_invalid_attributes
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #clock_out' do
    context 'with valid parameters' do
      it 'updates the sleep record' do
        post :clock_out, params: clock_out_valid_attributes
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post :clock_out, params: clock_out_invalid_attributes
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
