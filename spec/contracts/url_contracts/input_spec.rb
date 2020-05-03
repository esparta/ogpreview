# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlContracts::Input do
  subject do
    described_class.new.call(input)
  end
  let(:input) do
    { url: value }
  end

  context 'requires an url' do
    context 'valid input' do
      let(:value) { 'http://example.com' }
      it { is_expected.to be_success }
    end

    context 'empty params' do
      let(:input) do
        {} # Empty parameter
      end
      it { is_expected.to be_failure }
      it do
        expect(subject.errors.to_h).to match(url: ['is missing'])
      end
    end

    context 'should be not empty' do
      context 'not like zero size char' do
        let(:value) { '' }
        it { is_expected.to be_failure }
      end
      context 'neither as space filled string' do
        let(:value) { '                  ' }
        it { is_expected.to be_failure }
      end
      context '`nil` is also not ok' do
        let(:value) { nil }
        it { is_expected.to be_failure }
      end
    end

    context 'should have more than 3 letters' do
      context 'less than 4 is a' do
        let(:value) { 'xyz' }
        it { is_expected.to be_failure }
      end
      context 'more or equal than 4 is OK' do
        let(:value) { 'http://localhost' }
        it { is_expected.to be_success }
      end
    end

    context 'url should be less than 300 chars' do
      let(:value) { 'a' * 301 }
      it { is_expected.to be_failure }
    end
  end
end
