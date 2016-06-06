module Globase
  class Resource < Base

    def reload
      self.class.find(id)
    end

    def delete(params = {})
      self.class.send_request(:delete, params, id)
    end

    def create(data, params = {})
      if persisted
        update(params)
      else
        response_data = self.class.send_request(:post, params, nil, data)
        id = response_data[:id]
        persisted = true
      end
    end

    def update(params = {})
      if persisted
        self.class.send_request(:put, params, id, data)
        persisted = true
      else
        create(data, params = {})
      end
    end

    class << self

      def find(id, params = {})
        r = new( send_request(:get, params, id) )
        r.persisted = true
        r
      end

      def all(params = {})
        send_request(:get, params).collect do |d|
          r = new(d)
          r.persisted = true
          r
        end
      end

      def resource(params = {})
        @resource ||= RestClient::Resource.new( base_url, headers: headers(params), timeout: timeout )
      end

      def send_request(method = :get, params = {}, relative_path = nil, data = nil)
        #begin
          if relative_path.nil? || relative_path.to_s.strip.empty?
            request_resource = resource(params)["/"]
          else
            request_resource = resource(params)["/#{relative_path}"]
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