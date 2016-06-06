module Globase
  class ListProfile < NestedResource

    def update(params = {})
      if persisted
        self.class.send_request(parent, :put, params, nil, data)
        persisted = true
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


