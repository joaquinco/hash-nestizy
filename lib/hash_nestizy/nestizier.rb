# frozen_string_literal: true

module HashNestizy
  # Class that performs the actual hash nesting
  class Nestizier
    def initialize(hash_value, nesting_value, conflict_override: false)
      @hash_value = hash_value
      @nesting_value = nesting_value
      @conflict_override = conflict_override
    end

    def to_nested
      @hash_value.each_with_object({}) do |(key, value), ac|
        current = ac
        current_parent = ac

        unless [String, Symbol].any? { |t| key.is_a?(t) }
          ac[key] = value
          next
        end

        key_parts = key.to_s.split(@nesting_value)
        key_count = key_parts.length

        key_parts.each_with_index do |key_part, index|
          break unless current.is_a?(Hash)

          current_parent = current
          curr_value = index == key_count - 1 ? value : {}
          current = nested_insert(current, key_part, curr_value)
        end
      end
    end

    private

    def nested_insert(current, key, value)
      if key.include?('[')
        key_part_list = key.split('[')
        key = key_part_list[0]
        index = key_part_list[-1].to_i
        list = get_or_add_child(current, key, default: [])
        current[key] = list
        current = get_or_add_child(list, index, default: value)
      else
        current[key] = get_or_add_child(current, key, default: value)
        current = current[key]
      end

      current
    end

    def get_or_add_child(curr_child, key, default: nil)
      curr_child[key] = default unless curr_child[key] && !@conflict_override
      curr_child[key]
    end
  end
end
