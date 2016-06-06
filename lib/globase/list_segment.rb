module Globase
  class ListSegment < NestedResource

    class << self

      def all(parent, params = {})
        send_request(parent, :get, params).collect do |d|
          r = new( d.merge({ parent: parent }) )
          r.persisted = true
        end
      end

      def collection_name
        :segments
      end

      def fields
        @fields = super
      end

    end

  end
end