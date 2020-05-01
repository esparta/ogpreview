# frozen_string_literal: true

# Custom type for string
module Types
  include Dry::Types()

  StrippedString = Types::String.constructor(&:strip)
end

# Internet is a wierd place
# every user input should have a validation contract
class UrlContract < Dry::Validation::Contract
  params do
    required(:url).filled(Types::StrippedString,
                          min_size?: 4,
                          max_size?: 300) # The max shall be reviewd
  end
end
