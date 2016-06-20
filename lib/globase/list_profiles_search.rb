module Globase
  class ListProfilesSearch < NestedResource

    class << self

      def search(parent, criteria = {}, expand = "Profile", force_deferred = false, params = {})
        send_request( parent,
                      :post,
                      params.merge(force_deferred: force_deferred, expand: expand),
                      'search',
                      criteria
                    )
      end

      def collection_name
        :profiles
      end

      def fields
        @fields = super | [ :list, :sysCreated, :sysChanged, :optOutEmail, :optOutSms, :unConfirmed, :email, :company, :firstName, :lastName, :externalId ]
      end

    end

  end
end


