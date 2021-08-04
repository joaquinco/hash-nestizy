# frozen_string_literal: true

require 'byebug'

module ApiErrors
  # module_eval do
  # end

  # Transform a flat hash into nested hash.
  # Handy to use rails' ActiveRecord::Error in api mode.
  #
  # @param [Hash] hash_value The hash to be transformed.
  #
  # ==== Example
  #
  #   errors = {
  #     'name' => 'is required',
  #     'role.name' => 'max be longer than 5',
  #     'role.index' => 'alredy exists',
  #   }
  #   error_nested = to_nested(errors)
  #   error_nested == {
  #     'name' => 'is required',
  #     'role' => { 'name' => 'max be longer than 5', 'index' => 'alredy exists' },
  #   }
  #
  def to_nested(hash_value)
    hash_value.each_with_object({}) do |(key, value), ac|
      key_parts = key.split('.')

      current = ac
      current_parent = ac
      last_key = key

      key_parts.each do |key_part|
        current_parent = current
        current, last_key = nested_insert(current, key_part)
      end

      current_parent[last_key] = value
    end
  end

  def nested_insert(current, key)
    if key.include?('[')
      key_part_list = key.split('[')
      key = key_part_list[0]
      index = key_part_list[-1].to_i
      list = get_or_add_child(current, key, default: [])
      current[key] = list
      current = get_or_add_child(list, index)
    else
      current[key] = get_or_add_child(current, key)
      current = current[key]
    end

    [current, key]
  end

  private

  def get_or_add_child(curr_child, key, default: {})
    curr_child[key] = default unless curr_child[key]
    curr_child[key]
  end

  module_function(:to_nested)
  module_function(:nested_insert)
  module_function(:get_or_add_child)
end
