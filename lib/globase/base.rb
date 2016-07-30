module Globase
  class Base
    format 'json'

    attr_accessor :persisted

    def initialize(attributes = {})
      validation_errors = self.class.validate_data(:initialize, attributes)
      if validation_errors.any?
        validation_error_messages = validation_errors.join("\n - ")
        raise "Validation errors:\n - #{validation_error_messages}"
      end

      attributes.each do |k,v|
        send("#{ k }=", v)
      end
    end

    def url
      "#{self.class.base_url}/#{id}"
    end

    def data
      Hash[self.class.data_fields.collect{|a| [a, send(a) ]}]
    end

    def save(params = {})
      if persisted
        update(params)
      else
        create(data, params)
      end
    end

    class << self

      def fields
        @fields = [:id]
      end

      def set_fields
        fields.each do |a|
          attr_accessor a
        end
      end

      def validate_data(method, data)
        errors = []
        return errors if data.nil?
        fields_data = data.keys
        case method
        when :put
          fields_mandatory = fields_mandatory_update
        when :post
          fields_mandatory = fields_mandatory_create
        when :initialize
          fields_mandatory = fields_mandatory_initialize
        end

        fields_matching = fields_data & fields_mandatory
        fileds_missing = fields_mandatory - fields_matching

        errors << "Mandatory fields missing: #{fileds_missing.join(', ')} for #{self}" if fileds_missing.any?

        errors
      end

      def data_fields
        fields - fields_ignore_for_data
      end

      def fields_ignore_for_data
        [:parent]
      end

      def fields_mandatory_initialize
        []
      end

      def fields_mandatory_create
        []
      end

      def fields_mandatory_update
        [:id]
      end

      def collection_name
        self.name.demodulize.downcase.pluralize.downcase
      end

      def base_url(parent = nil)
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

      def  debug_request(request_resource, method, params, data)
        if Globase.config.debug
          puts "#{'-'*80}"
          puts "  Resquest"
          puts "#{'-'*80}"
          puts " resource: #{request_resource}"
          puts " method: #{method}"
          puts " params: #{params.inspect}"
          puts " data: #{data.inspect}"
          puts " validation_errors: #{validate_data(method, data).inspect}"
          puts "#{'-'*80}\n"
        end
      end

      def debug_response(response)
        if Globase.config.debug
          puts "#{'*'*80}"
          puts "  Response"
          puts "#{'*'*80}"
          puts " code:    #{response.code}"
          puts " headers: #{response.headers.inspect}"
          puts " body:    #{response.body}"
          puts "#{'*'*80}\n"
         end
      end


    end

  end
end