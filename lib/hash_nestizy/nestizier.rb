# frozen_string_literal: true

module HashNestizy
  # Class that performs the actual hash nesting
  class Nestizier
    def initialize(hash_value, nesting_value)
      @hash_value = hash_value
      @nesting_value = nesting_value
    end

    def to_nested
      @hash_value.each_with_object({}) do |(key, value), ac|
        key_parts = key.split(@nesting_value)

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

    private

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

    def get_or_add_child(curr_child, key, default: {})
      curr_child[key] = default unless curr_child[key]
      curr_child[key]
    end
  end
end
