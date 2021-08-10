# frozen_string_literal: true

require 'hash_nestizy/hash_extensions'
require 'hash_nestizy/nestizier'

module HashNestizy # :nodoc:
  # = Converts hash keys to nested hash
  #
  # Transform a flat hash into nested hash.
  # Handy to use rails' ActiveRecord::Error in api mode.
  #
  # @param [Hash] hash_value The hash to be transformed.
  #
  # ==== Example
  #
  #  errors = {
  #    'name' => 'is required',
  #    'role.name' => 'max be longer than 5',
  #    'role.index' => 'alredy exists',
  #  }
  #  errors_nested = HashNestizy.to_nested(errors)
  #  errors_nested == {
  #    'name' => 'is required',
  #    'role' => { 'name' => 'max be longer than 5', 'index' => 'alredy exists' },
  #  }
  #
  def self.to_nested(hash_value, nesting_value: '.')
    nestizier = Nestizier.new(hash_value, nesting_value)

    nestizier.to_nested
  end

  # = Patch Hash class to add instance method `nestizy`
  #
  # ==== Example
  #
  #  HashNestizy.patch_hash!
  #  errors = { 'role.name' => 'is required' }
  #  errors_nested = errors.nestizy
  #  errors_nested == { 'role' => { 'name' => 'is required' } }
  #
  def self.patch_hash!
    Hash.class_eval { include HashNestizy::HashExtensions }
  end
end
