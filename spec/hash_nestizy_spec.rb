# frozen_string_literal: true

require 'hash_nestizy'
require 'byebug'

RSpec.describe HashNestizy do
  def to_nested(value)
    HashNestizy.to_nested(value)
  end

  shared_examples 'whats expected' do
    let(:received_hash) { to_nested(initial_hash) }

    it 'returns what\'s expected' do
      expect(received_hash).to eq(expected_hash)
    end
  end

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

    it_behaves_like 'whats expected'
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

    it_behaves_like 'whats expected'
  end

  describe 'many nested levels' do
    let(:many_nested_level_hash) do
      {
        'no.matter.walter[0].says' => 1
      }
    end
    let(:nested_levels) { %w[no matter walter] }
    let(:expected_hash) { to_nested(many_nested_level_hash) }

    it 'key is deeply nested' do
      expect(expected_hash.dig(*nested_levels)).to be_a(Array)
    end

    it 'deep nested key is as expected' do
      expect(expected_hash.dig(*nested_levels)[0]['says']).to eq 1
    end
  end

  describe 'does not break with non string keys' do
    let(:initial_hash) do
      {
        1 => 'is required',
        :user => 'Mariscala',
        'role.name' => 'alredy exists',
        [1, 2, 3] => ''
      }
    end
    let(:expected_hash) do
      {
        1 => 'is required',
        'user' => 'Mariscala',
        'role' => { 'name' => 'alredy exists' },
        [1, 2, 3] => ''
      }
    end

    it_behaves_like 'whats expected'
  end

  describe 'does not break with key conflicts' do
    let(:initial_hash) do
      {
        'role' => 'is required',
        'role.name' => 'is required'
      }
    end
    let(:received_hash) { to_nested(initial_hash) }

    it 'includes a role key' do
      expect(received_hash).to include('role')
    end
  end

  describe 'hash patch' do
    it 'calls HashNestizy.to_nested on nestizy called' do
      allow(described_class).to receive(:to_nested)

      described_class.patch_hash!
      { 'role.name' => '1' }.nestizy

      expect(described_class).to have_received(:to_nested)
    end
  end
end
