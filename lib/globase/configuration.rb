# encoding: utf-8
module Globase
  class Configuration

    attr_accessor :api_key
    attr_reader :timeout

    attr_accessor :debug

    attr_accessor :host
    attr_accessor :host_port
    attr_accessor :host_protocol

    attr_reader :log_file_path


    def log_file_path=(value)
      @log_file_path = value
      if value.nil?
        RestClient.log = value
      else
        RestClient.log = Logger.new(value)
      end
    end

    # Configuration defaults
    def initialize
      @api_key                        = nil
      @timeout                        = 30
      @debug                          = true
      @host                           = 'rest.globase.com'
      @host_port                      = 443
      @host_protocol                  = 'https'
    end

  end
end


