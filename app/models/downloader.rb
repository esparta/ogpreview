# frozen_string_literal: true

require 'down/http'
require 'dry/monads'

# Wrapper around Down class
class Downloader
  class << self
    def get(src)
      new.get(src)
    end
  end

  include Dry::Monads[:try, :result]

  def get(src)
    Try do
      Down::Http.open(src).read
    end.to_result
  end
end
