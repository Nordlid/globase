module Globase
  class ListSchema < NestedResource

    class << self

      def get(parent, params = {})
        data = send_request(parent, :get, params)
        s = new( data.merge({ parent: parent }) )
        s.persisted = true
        s
      end

      def collection_name
        :schema
      end

      def fields
        @fields = super | ['Profile']
      end

    end

  end
end