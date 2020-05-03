# frozen_string_literal: true

require 'dry/monads/do'

class Downloader
  # Wrapper & mixin for review if address respond
  # via HEAD request, and if correct, using
  # ::OpenGraph to parse the website
  class OpenGraph
    class << self
      include Dry::Monads[:try, :result]
      include Dry::Monads::Do.for(:get)

      def get(src)
        checker = yield head(src)
        get_opengraph(checker)
      end

      private

      def head(src)
        Try do
          HTTP.head(src)
          src
        end.to_result
      end

      def get_opengraph(checker)
        Try do
          ::OpenGraph.new(checker)
        end.to_result
      end
    end
  end
end
