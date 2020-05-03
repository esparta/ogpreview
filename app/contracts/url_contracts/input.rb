# frozen_string_literal: true

# Custom type for string
module Types
  include Dry::Types()

  StrippedString = Types::String.constructor(&:strip)
end

# Internet is a wierd place
# every user input should have a validation contract
module UrlContracts
  # Used for POST / validation only
  class Input < Dry::Validation::Contract
    params do
      required(:url).filled(Types::StrippedString,
                            min_size?: 4,
                            max_size?: 300) # The max shall be reviewd
    end
    rule(:url) do
      key.failure(
        'Include a valid schema as http(s)://'
      ) unless values[:url].match(%r{^https?://})
    end
  end
end
