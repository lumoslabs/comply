require 'spec_helper'

describe Comply::ValidationsController do
  routes { Comply::Engine.routes }

  describe 'POST #create' do
    let(:model) { 'movie' }
    let(:fields) do
      {
        title: 'Encino Man',
        description: 'Brendan Frazier & Pauly Shore are "funny"',
        rating: 5,
        release_date: Date.today
      }
    end

    let(:params) do
      {
        :format => :json,
        :model => model,
        model => fields
      }
    end

    subject { get :show, params }

    context 'when model is valid' do
      it 'returns success' do
        subject
        expect(response).to be_success
      end

      it 'returns no errors' do
        subject
        expect(response_body).to eql({'error' => {}})
      end
    end

    context 'with invalid fields' do
      let(:fields) do
        {
          title: nil,
          description: 'Brendan Frazier & Pauly Shore are "funny"',
          rating: 5,
          release_date: Date.today
        }
      end

      it 'returns an error message' do
        subject
        expect(response_body['error']).to include('title' => ["can't be blank"] )
      end
    end

    context 'without a model given' do
      let(:model) { '' }

      it 'returns an error' do
        subject
        expect(response_body).to eql({'error' => 'Model not found'})
        expect(response.status).to be(500)
      end
    end

    context 'without fields given' do
      let(:fields) { {} }

      it 'returns an error' do
        subject
        expect(response_body).to eql({'error' => 'Form fields not found'})
        expect(response.status).to be(500)
      end
    end
  end
end

private

def response_body
  JSON.parse(response.body)
end
