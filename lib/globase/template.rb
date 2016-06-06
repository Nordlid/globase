module Globase
  class Template < Resource

    def show(params = {})
      raise NoMethodError
    end

    def update(data, params = {})
      raise NoMethodError
    end

    def delete(params = {})
      raise NoMethodError
    end

    class << self

      def create(data, params = {})
        raise NoMethodError
      end

      def find(id, params = {})
        all.select{|l| l.id == id.to_i }.first
      end

      def all(params = {})
        super(params)
      end

      def fields
        @fields = super | [:id, :name, :description, :config, :image ]
      end

    end

  end
end