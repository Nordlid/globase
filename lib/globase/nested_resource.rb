module Globase
  class NestedResource < Base

    def reload
      self.class.find(parent, id)
    end

    def delete(params = {})
      self.class.send_request(parent, :delete, params, id)
    end

    def create(data, params = {})
      if persisted
        update(params)
      else
        response_data = self.class.send_request(parent, :post, params, nil, data)
        id = response_data[:id]
        persisted = true
      end
    end

    def update(params = {})
      if persisted
        self.class.send_request(parent, :put, params, id, data)
        persisted = true
      else
        create(data, params = {})
      end
    end

   class << self

      def find(parent, id, params = {})
        data = send_request(parent, :get, params, id)
        r = new( data.merge({ parent: parent }) )
        if data.any?
          r.persisted = true
        else
          return
        end
        r
      end

      def fields_mandatory_initialize
        [:parent]
      end

      def resource(parent, params = {})
        @resource ||= RestClient::Resource.new( base_url( parent ), headers: headers(params), timeout: timeout )
      end

      def base_url(parent)
        "#{parent.url}/#{collection_name}"
      end

      def fields
        @fields = super | [:parent]
      end

      def send_request(parent, method = :get, params = {}, id = nil, data = nil)
        #begin
          if id.nil?
            request_resource = resource(parent, params)["/"]
          else
            request_resource = resource(parent, params)["/#{id}"]
          end
          debug_request(request_resource, method, params, data)

          if data.nil?
            response = request_resource.send(method)
          else
            validation_errors = validate_data(method, data)
            if validation_errors.empty?
              response = request_resource.send(method, data.to_json)
            else
              validation_error_messages = validation_errors.join("\n - ")
              raise "Validation errors:\n - #{validation_error_messages}"
            end
          end

          debug_response(response)
          parse(response.body)
         #rescue => e
         #  if e.respond_to?(:response)
         #    e.response
         #  else
         #    raise e
         #  end
        #end
      end

    end

  end
end