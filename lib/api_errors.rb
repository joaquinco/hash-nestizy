# frozen_string_literal: true

module ApiErrors
  # module_eval do
  # end

  ##
  # Transform a rails errors hash into nested hash of errors.
  def to_nested(error_hash)
    ret = {}
    error_hash.map do |key, value|
      key_parts = key.split('.')

      current = ret
      child = ret
      last_key = key
      key_parts.each do |key_part|
        current = child
        if key_part.include?('[')
          key_part_list = key_part.split('[')
          key_part = key_part_list[0]
          index = key_part_list[-1].to_i
          list = get_or_add_child(child, key_part, default: [])
          current[key_part] = list
          child = get_or_add_child(list, index, default: {})
        else
          child = get_or_add_child(child, key_part)
          current[key_part] = child
        end
        last_key = key_part
      end

      current[last_key] = value
    end

    ret
  end

  private

  def get_or_add_child(curr_child, key, default: {})
    curr_child[key] = default unless curr_child[key]
    curr_child[key]
  end

  module_function(:to_nested)
  module_function(:get_or_add_child)
end
