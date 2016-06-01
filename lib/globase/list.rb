module Globase
  class List < Resource

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

      def all(params = {})
        super(params)
      end

    end

  end
end