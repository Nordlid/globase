module Globase
  class Resource
    format 'json'

    def initialize(id)
      @id = id
    end

    def id
      @id
    end

    def show(params = {})
      self.class.send_request(:get, params, id)
    end

    def update(data, params = {})
      self.class.send_request(:put, params, id, data)
    end

    def delete(params = {})
      self.class.send_request(:delete, params, id)
    end

    def url
      "#{self.class.base_url}/#{id}"
    end

    class << self

      def create(data, params = {})
        send_request(:post, params, nil, data)
      end

      def all(params = {})
        send_request(:get, params)
      end

      def  debug_request(request_resource, method, params, data)
        if Globase.config.debug
          puts "\n#{'-'*80}"
          puts "  Resquest"
          puts "#{'-'*80}"
          puts " resource: #{request_resource}"
          puts " method: #{method}"
          puts " params: #{params.inspect}"
          puts " data: #{data.inspect}"
          puts " validation_errors: #{validate_data(method, data).inspect}"
          puts "#{'-'*80}\n\n"
        end
      end

      def debug_response(response)
        if Globase.config.debug
          puts "\n#{'*'*80}"
          puts "  Response"
          puts "#{'*'*80}"
          puts " code:    #{response.code}"
          puts " headers: #{response.headers.inspect}"
          puts " body:    #{response.body}"
          puts "#{'*'*80}\n\n"
         end
      end

      def resource(params = {})
        @resource ||= RestClient::Resource.new( base_url, headers: headers(params), timeout: timeout )
      end


      def url
        "#{base_url}/"
      end

      def validate_data(method, data)
        errors = []
        return errors if data.nil?
        data_fields = data.keys
        case method
        when :put
          mandatory_fields = mandatory_fields_update
        when :post
          mandatory_fields = mandatory_fields_create
        end

        matching_fields = data_fields & mandatory_fields
        missing_fileds = mandatory_fields - matching_fields

        errors << "Mandatory fields missing: #{missing_fileds.join(', ')}" if missing_fileds.any?

        errors
      end

      def mandatory_fields_create
        []
      end

      def mandatory_fields_update
        []
      end

      def send_request(method = :get, params = {}, id = nil, data = nil)
        begin
          if id.nil?
            request_resource = resource(params)["/"]
          else
            request_resource = resource(params)["/#{id}"]
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
        rescue => e
          if e.respond_to?(:response)
            e.response
          else
            raise e
          end
        end
      end

      def collection_name
        self.name.demodulize.downcase.pluralize.downcase
      end

      def base_url
        "#{host_url}/#{collection_name}"
      end


      def parse(body)
        JSON.parse(body)
      end

      def timeout
        Globase.config.timeout
      end

      def headers(params = {})
        {
          params: default_params.merge(params),
          content_type: :json,
          accept: :json,
        }
      end

      def default_params
        {
          api_key: Globase.config.api_key
        }
      end

      def host_url
        "#{host_protocol}://#{host}:#{host_port}"
      end

      def host
        Globase.config.host
      end

      def host_port
        Globase.config.host_port
      end

      def host_protocol
        Globase.config.host_protocol
      end

    end

  end
end