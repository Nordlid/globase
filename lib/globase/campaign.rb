module Globase
  class Campaign < Resource

    def update(params = {})
      super(params = {})
    end

    def delete(params = {})
      raise NoMethodError
    end

    class << self

      def create(data, params = {})
        super(data, params = {})
      end

      def all(params = {})
        super(params)
      end

      def fields
        super | [:id, :list, :name, :type, :status, :sysCreated, :sysChanged, :ownerId, :ownerUsername, :ownerEmail, :spanCounts, :tags, :messages ]
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