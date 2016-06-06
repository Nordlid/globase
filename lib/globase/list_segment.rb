module Globase
  class ListSegment < NestedResource

    class << self

      def all(parent, params = {})
        send_request(parent, :get, params).collect do |d|
          r = new( d.merge({ parent: parent }) )
          r.persisted = true
          r
        end
      end

      def collection_name
        :segments
      end

      def fields
        @fields = super | [:name, :description, :profileCount, :sysCreated, :sysChanged]
      end

    end

  end
end