# frozen_string_literal: true

begin
  require "fast_woothee"
rescue LoadError
  # ok
end

module EarlyHintsHeader
  class Middleware
    RACK_KEY = "early_hints.links"

    def initialize(app)
      @app = app
    end

    def call(env)
      env["rack.early_hints"] = proc do |header|
        env[RACK_KEY] ||= []
        env[RACK_KEY] << header["Link"]
      end

      status, headers, body = @app.call(env)
      assign_headers(headers, env)
      clear_thread_locals

      [status, headers, body]
    end

    private

    def build_link_header(headers, env)
      links = [headers.delete("Link"), *env[RACK_KEY]]
      links.compact!
      links.join(",") if env.key?(RACK_KEY)
    end

    def clear_thread_locals
      Thread.current[:__hanami_assets] = nil
    end

    def pushable?(env)
      return true unless defined?(FastWoothee)
      return false unless env.key?(RACK_KEY)

      # ios caching with http2 push is unpredictable
      !FastWoothee.ios?(env["HTTP_USER_AGENT"])
    end

    def assign_headers(headers, env)
      return unless pushable?(env)

      headers["Link"] = build_link_header(headers, env)
    end
  end
end
