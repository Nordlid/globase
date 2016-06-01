require 'oj'
require 'oj_mimic_json'
require 'rest-client'
require 'active_support/inflector'
require 'active_support/core_ext/module/introspection'
require 'globase/configuration'
require 'globase/resource'
require 'globase/list'
require 'globase/campaign'

module Globase

  class << self

    def configure
      yield configuration
    end

    # Accessor for Adminsite::Configuration
    def configuration
      @configuration ||= Configuration.new
    end
    alias :config :configuration

  end

end

Globase.config.log_file_path = 'globase.log' if Globase.config.debug