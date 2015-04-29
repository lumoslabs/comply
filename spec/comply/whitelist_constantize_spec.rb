require 'spec_helper'
require 'comply/whitelist_constantize'

describe Comply::WhitelistConstantize do
  subject { Comply::WhitelistConstantize.constantize(string) }
  context 'in the whitelist' do
    context 'default matcher' do
      let(:string) { 'movie' }
      it 'permits ActiveModel::Validation objects' do
        expect(subject).to eq(Movie)
      end
    end

    context 'custom matcher' do
      let(:string) { 'array' }
      before { Comply::WhitelistConstantize.allow(Array) }

      it 'permits explicitly-whitelisted objects' do
        expect(subject).to eq(Array)
      end
    end

    context 'custom matcher subclass' do
      module Behavior
      end

      class Behaver
        include Behavior
      end

      let(:string) { 'behaver' }
      before { Comply::WhitelistConstantize.allow(Behavior, include_inheritance: true) }

      it 'permits inherited classes' do
        expect(subject).to eq(Behaver)
      end
    end
  end

  context 'not in the whitelist' do
    let(:string) { 'string' }
    it 'raises an error' do
      expect { subject }.to raise_error(Comply::WhitelistConstantize::NotWhitelistedError)
    end
  end
end
