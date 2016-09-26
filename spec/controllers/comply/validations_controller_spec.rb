require 'spec_helper'

describe Comply::ValidationsController, type: :controller do
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

    context 'with comply-skipped validations' do
      let(:fields) do
        {
          title: 'title',
          description: nil,
          rating: 5,
          release_date: Date.today
        }
      end

      it 'does not error' do
        expect(response).to be_success
      end

      specify 'even though the model is invalid' do
        movie = Movie.new(fields)
        expect(movie).to be_invalid
        expect(movie.valid?(:comply)).to eq(true)
      end

      context 'in a new validation_context' do
        class Comply::ValidationsController
          def validation_context
            :no_longer_comply
          end
        end

        it 'throws an error' do
          subject
          expect(response_body['error']).to include('description' => ["can't be blank"] )
        end
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

    context 'when model class does not exist' do
      let(:model) { 'thisisnotreal' }

      it 'returns an error' do
        subject
        expect(response_body).to eql({'error' => 'Model not found'})
        expect(response.status).to be(500)
      end
    end

    context 'when model is not validatable' do
      let(:model) { 'hash' }

      it 'returns an error' do
        subject
        expect(response_body).to eql({'error' => 'Model not found'})
        expect(response.status).to be(500)
      end
    end
  end
end

private

def response_body
  JSON.parse(response.body)
end
