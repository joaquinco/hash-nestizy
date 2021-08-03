# frozen_string_literal: true

require 'api_errors'

RSpec.describe ApiErrors do
  simple_hash = {
    'key_1' => 1,
    'key_string' => 'value is required',
    'key_array' => %w[value2 value3],
    'key_hash' => { 'value' => 'is required', 'value2' => 'is not' }
  }
  let(:nested_attribute_name) { 'nested_attribute' }

  describe 'single nested level' do
    let(:error_single_nested) do
      nested_entries = simple_hash.transform_keys { |key| "#{nested_attribute_name}.#{key}" }

      simple_hash.merge(nested_entries)
    end

    let(:error_nested) { ApiErrors.to_nested(error_single_nested) }

    it 'returns a new hash' do
      expect(error_nested).to be_a(Hash)
    end

    it 'has a nested entry' do
      expect(error_nested).to include(nested_attribute_name)
    end

    it 'neste entry is a Hash' do
      expect(error_nested[nested_attribute_name]).to be_a(Hash)
    end

    it 'nested hash is simple hash' do
      expect(error_nested[nested_attribute_name]).to eq(simple_hash)
    end
  end

  describe 'two nested levels' do
    let(:nested_entries_count) { 10 }
    let(:error_multiple_nested) do
      nested_entries = (0..nested_entries_count - 1).reduce({}) do |ac, index|
        single_nested_hash = simple_hash.transform_keys do |key|
          "#{nested_attribute_name}[#{index}].#{key}"
        end

        ac.merge(single_nested_hash)
      end

      simple_hash.merge(nested_entries)
    end

    let(:error_nested) { ApiErrors.to_nested(error_multiple_nested) }

    it 'returns a new hash' do
      expect(error_nested).to be_a(Hash)
    end

    it 'has a nested entry' do
      expect(error_nested).to include(nested_attribute_name)
    end

    it 'neste entry is an Array' do
      expect(error_nested[nested_attribute_name]).to be_a(Array)
    end

    it 'each nested hash is simple hash' do
      expect(error_nested[nested_attribute_name]).to eq([simple_hash] * nested_entries_count)
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
