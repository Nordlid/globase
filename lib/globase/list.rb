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

    def profile(id, params = {})
      ListProfile.find(self, id, params)
    end

    def profiles_search(criteria = {}, expand = nil, force_deferred = false, params = {})
      ListProfilesSearch.search(self, criteria, expand, force_deferred, params)
    end

    def schema(params = {})
      @schema ||= ListSchema.get(self, params)
    end

    def segments(params = {})
      @segments ||= ListSegment.all(self, params)
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
        @fields = super | [:id, :name, :description, :profileCount, :sysCreated, :sysChanged]
      end

    end

  end
end