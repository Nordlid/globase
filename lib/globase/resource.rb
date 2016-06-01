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

      def url
        "#{base_url}/"
      end

      def debug(response)
        if Globase.config.debug
          puts "#{'*'*80}"
          puts "response.code:    #{response.code}"
          puts "response.body:    #{response.body}"
          puts "response.headers: #{response.headers.inspect}"
          puts "#{'*'*80}"
         end
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
          headers: {
            accept: :json,
            :content_type => 'application/json'
          }
        }
      end

      def default_params
        {
          api_key: Globase.config.api_key
        }
      end

      def resource(params = {})
        @resource ||= RestClient::Resource.new( base_url, headers: headers(params), timeout: timeout )
      end

      def send_request(method = :get, params = {}, id = nil, data = {})
        begin
          if id.nil?
            request_resource = resource(params)["/"]
          else
            request_resource = resource(params)["/#{id}"]
          end

          if ( data.nil? || data.empty? )
            response = request_resource.send(method)
          else
            response = request_resource.send(method, data.to_json)
          end

          debug(response)
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