module Globase
  class ListProfile < NestedResource

    def update(params = {})
      if persisted
        response_data = self.class.send_request(parent, :put, params, nil, data)
        persisted = true
        response_data
      else
        create(data, params = {})
      end
    end

    class << self

      def collection_name
        :profile
      end

      def fields
        @fields = super | [ :list, :sysCreated, :sysChanged, :optOutEmail, :optOutSms, :unConfirmed, :email, :company, :firstName, :lastName, :externalId ]
      end

    end

  end
end


