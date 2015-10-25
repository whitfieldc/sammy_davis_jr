require "rack"

module Sammy
  class Base

    def initialize
      @routes = {}
    end

    attr_reader :routes

    def get(path, &handler)
      route("GET", path, &handler)
    end

    def call(env)
      @request = Rack::Request.new(env)
      verb = @request.request_method
      requested_path = @request.path_info

      handler = @routes.fetch(verb, {}).fetch(requested_path, nil)

      if handler
        handler.call
      else
        [404, {}, ["Oops! No route for #{verb} #{requested_path}"]]
      end

    end

    private

    def route(verb, path, &handler)
      @routes[verb] ||= {}
      @routes[verb][path] = handler
    end

  end
end

sammy = Sammy::Base.new

sammy.get "/hello" do
  [200, {}, ["EO 11"]]
end

Rack::Handler::WEBrick.run sammy, Port: 9292