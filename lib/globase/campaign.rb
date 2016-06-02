module Globase
  class Campaign < Resource

    def update(data, params = {})
      super(data, params = {})
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

      def mandatory_fields_create
        [:name, :list, :type]
      end

      def mandatory_fields_update
        [:name, :list, :type]
      end

    end

  end
end