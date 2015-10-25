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

puts sammy.routes