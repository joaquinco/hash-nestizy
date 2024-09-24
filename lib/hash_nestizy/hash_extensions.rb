# frozen_string_literal: true

module HashNestizy
  # = Hash extensions
  #
  # Extensions to the Hash class
  module HashExtensions
    def nestizy(sep = '.', override: false)
      HashNestizy.to_nested(
        self,
        sep: sep,
        override: override
      )
    end
  end
end
