module Globase
  class Campaign < Resource

    def user=(value)
      @ownerId = value
    end

    def update(params = {})
      super(params = {})
    end

    def delete(params = {})
      raise NoMethodError
    end

    def add_profile(list_profile, launchOptions = { data: nil }, params = {})
      if list_profile.is_a?(Numeric)
        profile_id = list_profile
      else
        profile_id = list_profile.id
      end
      self.class.send_request(:post, params, "#{id}/addProfile/#{profile_id}", launchOptions)
    end

    def add_profiles(list_profile_ids, params = {})
      self.class.send_request(:post, params, "#{id}/addProfiles", { profiles: list_profile_ids })
    end

    class << self

      def create(data, params = {})
        super(data, params = {})
      end

      def all(params = {})
        super(params)
      end

      def fields
        @fields = super | [:id, :list, :name, :type, :status, :sysCreated, :sysChanged, :ownerId, :ownerUsername, :ownerEmail, :spanCounts, :tags, :messages, :duplicateEmail ]
      end

      def mandatory_fields_create
        [ :name, :list, :type, :status, :ownerId ]
      end

      def mandatory_fields_update
        [ :name, :list, :type, :status, :ownerId ]
      end

    end

  end
end