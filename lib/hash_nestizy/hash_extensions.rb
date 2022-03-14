# frozen_string_literal: true

module HashNestizy
  # = Hash extensions
  #
  # Extensions to the Hash class
  module HashExtensions
    def nestizy(nesting_value = '.', conflict_override: false)
      HashNestizy.to_nested(
        self,
        nesting_value: nesting_value,
        conflict_override: conflict_override
      )
    end
  end
end
