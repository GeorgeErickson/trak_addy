require 'trak_addy/version'
require 'json'
require 'bonfig'
require 'faraday'
require 'active_model'
require 'active_support/core_ext/module/delegation'
require 'active_support/concern'
require 'active_support/inflector'
require 'trak_addy/railtie' if defined?(Rails)

module TrakAddy
  extend Bonfig

  bonfig do
    config :api_key
  end

  def self.client
    @client ||= Client.new(config.api_key)
  end

  class Client
    attr_reader :api_key
    def initialize(api_key)
      @api_key = api_key
    end

    def connection
      @connection ||= Faraday.new(url: "https://trak.addy.co/api/v1") do |faraday|
        faraday.response :logger
        # faraday.response :raise_error
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end


    def request(method, path, data = nil)
      data = JSON.dump(data) unless data.nil?

      res = connection.run_request(method, path, data, nil) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['trak-api-key'] = @api_key unless @api_key.nil?
      end

      JSON.load(res.body)
    end

    def post(path, data)
      request(:post, path, data)
    end

    def get(path)
      request(:get, path)
    end

    def put(path, data)
      request(:put, path, data)
    end

    def delete(path, data)
      request(:put, path, data)
    end
  end

  class Path
    def initialize(cls)
      @name = cls.name.demodulize.downcase
    end

    def singular
      @name
    end

    def plural
      @name.pluralize
    end

    def for_id(id)
      "#{singular}/#{id}"
    end

    def key
      "#{singular}Id"
    end

    def id_to_hash(id)
      out = {}
      out[key] = id
      out
    end

    def extract_id(data)
      data[key]
    end
  end

  module Endpoint
    extend ActiveSupport::Concern
    include ActiveModel::Model

    def client
      TrakAddy.client
    end

    def path
      self.class.path
    end

    def update(data)
      client.put(path.for_id(id), data)
    end

    def delete
      client.delete(path.plural, path.id_to_hash(id))
    end

    module ClassMethods
      def path
        Path.new(self)
      end

      def client
        TrakAddy.client
      end

      def all
        Collection.new(client.get(path.plural), self)
      end

      def create(data)
        res = client.post(path.plural, data)
        data.merge!(id: path.extract_id(res))
        new(data)
      end
    end
  end


  class Collection
    include Enumerable
    attr_accessor :elements, :resource_class

    delegate :to_xml, :to_yaml, :length, :collect, :map, :each, :all?, :include?, :to_ary, :size, :last, :first, :[], :to => :to_a

    def initialize(elements = [], resource_class = nil)
      @resource_class = resource_class
      @elements = elements.map do |e|
        resource_class.new(e)
      end
    end

    def to_a
      elements
    end
  end


  class Driver
    include Endpoint
    attr_accessor :id, :name, :status, :jobs

    def assign(job)
      job_id = job.respond_to?(:id) ? job.id : job
      client.put('drivers/job', {jobId: job_id, driverId: id})
    end
  end

  class Job
    include Endpoint
    attr_accessor :id, :recipientPhoneNumber, :destination, :address, :recipientData, :textDescription

    def assign(driver)
      driver_id = driver.respond_to?(:id) ? driver.id : driver
      client.put('drivers/job', {jobId: id, driverId: driver_id})
    end

    def unassign
      client.put('drivers/job', {jobId: id, driverId: nil})
    end
  end

  def self.create_key(email: nil, password: nil, name: nil)
    client.post('auth/keys', email: email, password: password, name: name)
  end
end
