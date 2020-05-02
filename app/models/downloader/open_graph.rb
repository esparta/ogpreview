# frozen_string_literal: true

class Downloader
  class OpenGraph
    class << self
      include Dry::Monads[:try, :result]
      def get(src)
        checker = head(src)
        get_opengraph(checker)
      end

      private

      def head(src)
        Try do
          HTTP.head(src)
          src
        end
      end

      def get_opengraph(checker)
        Try do
          ::OpenGraph.new(checker.value!)
        end
      end
    end
  end
end
