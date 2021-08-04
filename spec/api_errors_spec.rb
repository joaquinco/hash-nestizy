# frozen_string_literal: true

require 'api_errors'

RSpec.describe ApiErrors do
  describe 'single entry nested' do
    let(:initial_hash) do
      {
        'name' => 'is required',
        'role.name' => 'max be longer than 5',
        'role.index' => 'alredy exists'
      }
    end
    let(:expected_hash) do
      {
        'name' => 'is required',
        'role' => { 'name' => 'max be longer than 5', 'index' => 'alredy exists' }
      }
    end

    let(:received_hash) { ApiErrors.to_nested(initial_hash) }

    it 'returns what\'s expected' do
      expect(received_hash).to eq(expected_hash)
    end
  end

  describe 'multiple entry nested' do
    let(:initial_hash) do
      {
        'name' => 'is required',
        'role[1].name' => 'max be longer than 5',
        'role[1].index' => 'alredy exists',
        'role[2].name' => 'max be longer than 5'
      }
    end
    let(:expected_hash) do
      {
        'name' => 'is required',
        'role' => [
          nil,
          { 'name' => 'max be longer than 5', 'index' => 'alredy exists' },
          { 'name' => 'max be longer than 5' }
        ]
      }
    end
    let(:received_hash) { ApiErrors.to_nested(initial_hash) }

    it 'returns what\'s expected' do
      expect(received_hash).to eq(expected_hash)
    end
  end

  describe 'many nested levels' do
    let(:many_nested_level_hash) do
      {
        'no.matter.walter[0].says' => 1
      }
    end
    let(:nested_levels) { %w[no matter walter] }
    let(:error_nested) { ApiErrors.to_nested(many_nested_level_hash) }

    it 'key is deeply nested' do
      expect(error_nested.dig(*nested_levels)).to be_a(Array)
    end

    it 'deep nested key is as expected' do
      expect(error_nested.dig(*nested_levels)[0]['says']).to eq 1
    end
  end
end
