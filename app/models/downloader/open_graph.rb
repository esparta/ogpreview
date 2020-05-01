# frozen_string_literal: true

class Downloader
  class OpenGraph
    class << self
      include Dry::Monads[:try, :result]
      def get(src)
        downloader = Downloader.get(src)
        get_opengraph(downloader)
      end

      private

      def get_opengraph(downloader)
        Try do
          ::OpenGraph.new(downloader.value!)
        end.to_result
      end
    end
  end
end
